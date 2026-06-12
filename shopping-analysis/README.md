# Basic Data Exploration and Cleaning using Pandas

## Objective

The objective of this project is to perform basic data exploration and data cleaning using the Pandas library in Python. The project demonstrates loading a dataset, understanding its structure, handling missing values, removing duplicate records, performing basic data operations, creating derived features, and exporting a cleaned dataset for further analysis.

---

## Dataset Used

**File:** `Combined_dataset.csv`

The dataset contains product-level information including pricing, ratings, brand details, discounts, and other attributes.

---

## Project Workflow

### 1. Load Dataset

The CSV file was loaded into a Pandas DataFrame using `pd.read_csv()`.

```python
df = pd.read_csv(file_path)
```

Column names were standardized by converting them to lowercase and removing extra spaces.

---

### 2. Data Exploration

The following exploratory operations were performed:

* Displayed first five rows (`head()`)
* Displayed last five rows (`tail()`)
* Checked dataset dimensions (`shape`)
* Listed all column names
* Inspected data types
* Generated dataset information using `info()`
* Produced descriptive statistics using `describe()`

These steps helped in understanding the structure and quality of the data.

---

### 3. Missing Value Analysis

Missing values were identified using:

```python
df.isnull().sum()
```

Actions performed:

* Removed completely empty rows.
* Filled missing numeric values with the median.
* Filled missing text values with `"Unknown"`.

This ensured data consistency without losing excessive information.

---

### 4. Basic Data Operations

#### Row Filtering

Products with a final price greater than 1000 were filtered:

```python
expensive_products = df[df['final_price'] > 1000]
```

#### Column Selection

Relevant columns were selected for focused analysis:

```python
selected_df = df[['product_name', 'brand', 'final_price']]
```

---

### 5. Duplicate Removal

Duplicate records were identified using:

```python
df.duplicated().sum()
```

Any duplicates found were removed using:

```python
df.drop_duplicates()
```

This improved data quality and prevented redundant records.

---

### 6. Derived Column Creation

The original assignment requested:

```text
total_amount = price × quantity
```

However, the provided dataset does not contain `price` and `quantity` columns.

To demonstrate feature engineering, a new derived column was created:

```python
saved_amount = initial_price - final_price
```

This represents the amount saved by the customer after discounts.

---

### 7. Insights Generated

Basic insights were generated from the cleaned dataset:

* Top 10 brands by occurrence
* Average final product price
* Maximum final product price

These insights provide a quick overview of the dataset.

---

### 8. Export Cleaned Dataset

The cleaned dataset was exported as:

```text
Cleaned_Combined_dataset.csv
```

using:

```python
df.to_csv(output_path, index=False)
```

---

## Output Files

### 1. Jupyter Notebook

```text
Data_Exploration_Cleaning.ipynb
```

Contains the complete implementation and analysis.

### 2. Cleaned Dataset

```text
Cleaned_Combined_dataset.csv
```

Contains the processed and cleaned data.

### 3. README File

```text
README.md
```

Documents the workflow, methodology, and project outcomes.

---

## Conclusion

The project successfully demonstrates fundamental Pandas operations including data loading, exploration, cleaning, transformation, filtering, duplicate removal, feature engineering, and data export. The final cleaned dataset is ready for further analysis and visualization.
