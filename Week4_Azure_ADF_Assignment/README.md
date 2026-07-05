# Week 4 Assignment — Azure Cloud Fundamentals and Data Pipeline Implementation using ADF

## Objective
To understand Azure cloud concepts and build a complete data pipeline using a Storage Account and Azure Data Factory (ADF).



## Folder Structure

```
Week4_Azure_ADF_Assignment/
│
├── Task1_ResourceGroup/
│   └── resource_group_overview.png
│
├── Task2_StorageSetup/
│   └── container_with_uploaded_file.png
│
├── Task3_ADF_Basics/
│   ├── linked_service.png
│   ├── dataset_config.png
│   └── get_metadata_activity_output.png
│
├── Task4_PipelineDevelopment/
│   └── pipeline_design.png
│
├── Task5_PipelineExecution/
│   └── pipeline_run_succeeded.png
│
├── Task6_IAM_Roles/
│   └── role_assignments.png
│
├── MiniProject/
│   ├── pipeline_design.png
│   ├── pipeline_succeeded.png
│   ├── metadata_validated.png
│   └── data_copied_destination.png
│
└── README.md
```



### Task 1: Resource Group
Created a resource group `rg-week4-adf` in the East US region to hold all project resources.

### Task 2: Storage Setup
Created a storage account `stweek4adfrn2026`, added a blob container `week4-data`, and uploaded the source CSV file (`Sample - Superstore.csv`) into it.

### Task 3: ADF Basics
- Created Azure Data Factory `adf-week4-demo` and explored the Author, Monitor, and Manage sections of ADF Studio.
- Created a Linked Service (`stweek4adfrn2026`) connecting ADF to the Blob Storage account.
- Created two datasets: `ds_SourceCSV` (input file) and `ds_DestinationCSV` (output file location: `week4-data/output/result.csv`).
- Added a **Get Metadata** activity on `ds_SourceCSV` to retrieve item name, size, and last modified date — ran successfully.

### Task 4: Pipeline Development
Built pipeline `pl_Week4_Metadata` containing:
- **Get Metadata** activity — validates the source file.
- **Copy Data** activity — copies data from `ds_SourceCSV` to `ds_DestinationCSV`.

### Task 5: Pipeline Execution
Ran the pipeline in Debug mode. Both activities completed with status **Succeeded**, confirmed via the Output tab and the Monitor section.

### Task 6: IAM Roles
Assigned **Reader** and **Contributor** roles to the user account at the resource group (`rg-week4-adf`) scope via Access Control (IAM).

## Mini Project — End-to-End Pipeline

**Problem Statement:** Build a complete pipeline that reads a CSV file from Blob Storage and processes it using Azure Data Factory.

**Flow:** Get Metadata (validation) → Copy Data (source → destination)

**Result:**
- ✅ Pipeline executed successfully (Status: Succeeded)
- ✅ Data copied to destination (`result.csv`, 2.18 MiB, matching source size, found in `week4-data/output/`)
- ✅ Metadata validated (item name, size, last modified retrieved via Get Metadata activity)

## Conclusion
This project demonstrates a complete, working data pipeline in Azure Data Factory — from raw CSV ingestion in Blob Storage, through metadata validation, to a successful copy operation at a new destination — along with proper role-based access control at the resource group level.