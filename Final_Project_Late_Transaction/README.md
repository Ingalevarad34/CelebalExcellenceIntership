# Late Transaction Handling & Historical Revenue Correction Platform

A Databricks-native, Medallion-architecture (Bronze → Silver → Gold) pipeline built with PySpark and Delta Lake that detects sales transactions ingested after their true transaction date, and surgically recomputes only the historical revenue figures those late arrivals affect — with a full Delta-native audit trail.

**Tech Stack:** Python · PySpark · SQL · Databricks · Delta Lake

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Repository Contents](#repository-contents)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Pipeline Stages](#pipeline-stages)
- [Data Quality Checks](#data-quality-checks)
- [Re-running the Pipeline](#re-running-the-pipeline)
- [Validated Results](#validated-results)
- [Known Gaps & Future Work](#known-gaps--future-work)
- [Documentation](#documentation)

---

## Overview

Sales transactions rarely arrive the moment they happen — network delays, offline point-of-sale systems, third-party payment processors, and batch ETL windows all mean a transaction from Day 1 can land in the warehouse on Day 10 or Day 30. A pipeline that only ever appends new data leaves every historical report it already published silently wrong.

This platform closes that gap automatically:

1. **Detects** late arrivals by comparing `ingestion_date` against `txn_date`.
2. **Isolates** the exact set of historical dates each late arrival invalidates.
3. **Recomputes** revenue for only those dates using the complete dataset.
4. **Merges** the correction into the Gold table via Delta Lake's ACID `MERGE`, leaving every unaffected date untouched.
5. **Preserves** a full, queryable audit trail of every correction via Delta time-travel.

## Architecture

```
Bronze (raw truth, Auto Loader, checkpointed)
 |
 v
Silver (deduplicated, typed, quality-filtered)
 |
 +--> Late Detection (ingestion_date > txn_date) --+
 |                                                 |
 +--> Affected-Date Set D ------------------------>+--> Recompute(D) --> MERGE --> Gold
 |
 +--> Data Quality Checks (null / dup / negative) --> Quarantine
```

| Layer  | Delta Path        | Responsibility                                              |
|--------|--------------------|--------------------------------------------------------------|
| Bronze | `.../bronze/sales` | Raw ingestion via Auto Loader — immutable, exactly-once      |
| Silver | `.../silver/sales` | Dedup on `txn_id`, date casting, drop invalid amounts        |
| Gold   | `.../gold/revenue` | Daily revenue, partitioned by `txn_date`, MERGE-corrected    |

## Repository Contents

| File                                          | Description                                                                 |
|------------------------------------------------|-------------------------------------------------------------------------------|
| `late_txn_pipeline.py`                          | The Databricks notebook — full pipeline, source format, run top to bottom.   |
| `Late_Transaction_Handling_Report.docx`         | Design documentation with a verified objectives-vs-implementation gap analysis. |
| `Late_Transaction_Project_Report.docx`          | Formal final-project report — abstract, theory, architecture, and validated results. |
| `README.md`                                     | This file.                                                                    |

## Prerequisites

- A Databricks workspace with **Unity Catalog** enabled
- A cluster on a current Databricks Runtime (Delta Lake, `spark`, and `dbutils` are pre-loaded — no installs required)
- Permission to create schemas and volumes in the target catalog (default: `workspace`)

## Setup

1. **Import the notebook.** Open `late_txn_pipeline.py` in your Databricks workspace (Workspace → Import).
2. **Configure the catalog/schema** if not using the defaults:
   ```python
   CATALOG = "workspace"
   SCHEMA  = "late_txn_pipeline"
   ```
3. **Run the setup cells** (`0. Configuration` and `0a. First-time setup`). This creates the schema, the `pipeline_data` volume, the landing folder, and the `watermark` table, and prints the exact landing path to upload to.
4. **Upload your source CSV** (e.g. `sales_2000_rows.csv`) into the printed landing path, via Catalog Explorer or:
   ```python
   dbutils.fs.cp("file:/path/to/sales_2000_rows.csv", LANDING_PATH)
   ```
5. **Run All.**

### Required input schema

| Column           | Type   | Notes                                  |
|-------------------|--------|------------------------------------------|
| `txn_id`          | string | Unique transaction identifier            |
| `txn_date`        | date   | When the transaction actually occurred   |
| `ingestion_date`  | date   | When the record reached the warehouse    |
| `amount`          | number | Transaction value; must be > 0 to count  |

## Pipeline Stages

1. **Bronze — Raw Ingestion.** Auto Loader (`cloudFiles`) ingests every CSV in the landing folder with `trigger(availableNow=True)`, checkpointed for exactly-once processing. A guard checks the landing folder up front and exits cleanly if it's empty.
2. **Silver — Cleansing & Deduplication.** Dates are standardized with `to_date()`; duplicates on `txn_id` are resolved with a `row_number()` window (earliest `ingestion_date` wins); non-positive amounts are dropped.
3. **Data Quality Checks.** Null `txn_id` rows are quarantined to a dedicated Delta table; duplicate and negative-amount rows are counted (see [Known Gaps](#known-gaps--future-work)).
4. **Gold — Daily Aggregation.** Silver is aggregated to `daily_revenue`, partitioned by `txn_date`.
5. **Late Detection.** Rows where `ingestion_date > txn_date` are flagged as late.
6. **Historical Backfill.** The distinct set of affected dates is recomputed from the full Silver dataset and upserted into Gold via Delta `MERGE` — only those dates change.
7. **Audit Trail.** `DESCRIBE HISTORY` on the Gold table exposes every version, including each correction MERGE.
8. **Watermark.** The latest processed `txn_date` is recorded (write path only — see below).

## Data Quality Checks

| Check              | Logic                              | Current Behaviour                                       | Status                  |
|---------------------|--------------------------------------|-------------------------------------------------------------|---------------------------|
| Null `txn_id`       | `filter(col('txn_id').isNull())`     | Written to a quarantine Delta table                          |  Implemented            |
| Duplicate `txn_id`  | `groupBy` + count filter             | Counted only; survivor kept, losing rows discarded            | implemented |
| Negative amount     | `filter(col('amount') < 0)`          | Counted only; rows dropped by the `amount > 0` filter         |  implemented |

## Re-running the Pipeline

The notebook is safe to **Run All** repeatedly:

- Auto Loader checkpointing skips already-ingested files.
- Silver/Gold writes are full `overwrite`s of their own tables each run.
- The backfill MERGE only touches dates with late arrivals — everything else is left untouched, and the step is skipped entirely if there are no late transactions.

## Validated Results

Core transformation logic (dedup, late-arrival detection, affected-date recompute) was validated against a synthetic dataset of **1,982 transactions** with deliberately injected anomalies:

```
Late transactions detected                          : 438 / 1,882 (23.27%)
Distinct historical dates affected by late arrivals  : 88
Total corrected revenue across affected dates        : +$11,893.21
Largest single-date correction                       : +29.7% (2026-03-01)
```

Full methodology and the complete results table are in `Late_Transaction_Project_Report.docx`.

## Known Gaps & Future Work

- **Duplicate & negative-amount evidence** is currently counted but not persisted — extend the existing null-key quarantine pattern to these two checks.
- **Watermark is write-only** — it's updated every run but never read back to filter what gets reprocessed; wiring this up would make reprocessing genuinely incremental instead of full-dataset every run.
- **Predictive lateness scoring** — once enough Gold-layer history accumulates, model which sources/dates are statistically likely to receive late corrections.
- **Multi-cloud generalization** — abstract beyond the current Databricks/Delta-specific implementation.

## Documentation

- `Late_Transaction_Handling_Report.docx` — design doc + objective-by-objective verification against the running code.
- `Late_Transaction_Project_Report.docx` — formal report with theoretical grounding (event time vs. ingestion time, lateness as a predicate, MERGE as idempotent correction) and full validation results.

---

