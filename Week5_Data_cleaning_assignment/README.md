Week 5 - Spark Data Cleaning Assignment

Dataset used: Sample - Superstore.csv

About this assignment

This is Week 5 assignment on Spark Data Cleaning using PySpark. I used the Superstore
dataset instead of the generic column names given in the question, so I mapped the
columns like this:


user_id -> Customer ID
transaction_date -> Order Date
region -> Region
product_category -> Category
sale_amount / price -> Sales
city -> City
status -> Ship Mode
store_id -> State (dataset has no store id, so used State)



Setup code used

pythonimport os, sys

os.environ["JAVA_HOME"] = r"C:\Program Files\Eclipse Adoptium\jdk-17.0.13-hotspot"
os.environ["PATH"] = os.environ["JAVA_HOME"] + r"\bin;" + os.environ["PATH"]
os.environ["PYSPARK_PYTHON"] = sys.executable
os.environ["PYSPARK_DRIVER_PYTHON"] = sys.executable

from pyspark.sql import SparkSession
from pyspark.sql import functions as F

spark = SparkSession.builder.appName("Week5-Superstore").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

df = spark.read.csv(
    r"Data\Sample - Superstore.csv",
    header=True,
    inferSchema=True,
    quote='"',
    escape='"',
    multiLine=True,
)

Answers

Q1. Limitations of MapReduce vs Spark
MapReduce writes to disk after every step which is slow. Spark keeps data in
memory so it is much faster, especially for jobs that need multiple passes over
the same data.

Q2. How in-memory computing helps iterative ML algorithms
Spark can cache the dataset in RAM using .cache(), so every iteration of an
algorithm reads from memory instead of reading from disk again and again.

Q3. Remove duplicate rows based on user_id and transaction_date

pythondf.dropDuplicates(["Customer ID", "Order Date"])

Q4. Filter region West, group by category, average sale_amount

pythondf.filter(df.Region == "West") \
  .groupBy("Category") \
  .agg(F.avg("Sales").alias("avg_sale_amount"))

Q5. .na.drop() vs .na.fill()
.na.drop() removes rows that have null values.
.na.fill() replaces null values with something you choose.

pythondf.na.fill({"Ship Mode": "Unknown"})

Q6. Count of records per city where count > 100

pythondf.groupBy("City").count().filter(F.col("count") > 100)

Q7. How immutability affects cleaning
Spark DataFrames can't be changed directly. Every time you drop or rename a
column it creates a new DataFrame, so you have to reassign it back like
df = df.drop("column_name") otherwise the change doesn't actually happen.

Q8. Filter age between 18-30 and subscription Premium

pythondf.filter((df.age.between(18, 30)) & (df.subscription == "Premium"))

Q9. Why handle nulls before aggregation
Because sum() and avg() just ignore nulls automatically, which can give wrong
totals or averages without giving any error. Better to clean nulls first so
the result is correct.

Q10. Cast raw_timestamp to TimestampType, rename to event_time

pythondf.withColumn("event_time", F.to_timestamp(F.col("Order Date"), "M/d/yyyy")) \
  .drop("Order Date")

Q11. What is Shuffle and why groupBy is a wide transformation
Shuffle means moving data between partitions/machines so that rows with the
same key end up together. It's expensive because of network and disk usage.
groupBy needs a shuffle because same keys can be spread on different
partitions, so it is called a wide transformation. filter is narrow because
it doesn't need data from other partitions.

Q12. Remove rows where email is null or username is empty

pythondf.filter(df.email.isNotNull() & (df.username != ""))

Q13. Using .agg() for multiple stats at once

pythondf.agg(
    F.min("Sales").alias("min_price"),
    F.max("Sales").alias("max_price"),
    F.mean("Sales").alias("mean_price")
)

Q14. Risk of inferSchema=True with messy date formats
If dates are in different formats, Spark might not recognize the column as a
date type at all and treat it as string, or turn some values into null
without any warning. I actually faced something similar - Sales column got
read as string because of inconsistent quotes in the Product Name column.

Q15. Final pipeline - dedupe, fill nulls, group by store, total revenue

pythondf_cleaned = df.dropDuplicates().na.fill({"Sales": 0})

result = df_cleaned.groupBy("State") \
    .agg(F.sum("Sales").alias("total_revenue")) \
    .orderBy(F.desc("total_revenue"))

Saving the cleaned dataset

Since Spark's write.csv() wasn't working because of the Hadoop issue, I saved
the cleaned data using plain Python instead:

pythonimport csv, os

rows = df_cleaned.collect()
columns = df_cleaned.columns

output_path = r"Output\Cleaned_Superstore.csv"
os.makedirs(os.path.dirname(output_path), exist_ok=True)

with open(output_path, "w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(columns)
    for row in rows:
        writer.writerow(row)

Final file saved at: Output/Cleaned_Superstore.csv (9994 rows, 21 columns)

