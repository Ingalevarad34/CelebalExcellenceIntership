Q1. Roles of Driver, Cluster Manager, Executor
Driver is the main program that creates the SparkSession, builds the DAG and
sends tasks. Cluster Manager (like YARN or Standalone) allocates resources
(cpu/memory) to the application. Executor actually runs the tasks on worker
nodes and stores data if it's cached.

Q2. How Lazy Evaluation improves performance
Spark doesn't run transformations right away, it just builds a plan (DAG).
It only actually runs everything when an action like show() or count() is
called. This lets Spark optimize the whole chain together instead of running
each step separately, and skip work that isn't actually needed for the result.

Q3. Read CSV with header and inferSchema

pythondf = spark.read.csv("data/source.csv", header=True, inferSchema=True)

Q4. CSV vs Parquet - storage and performance
CSV is row-based, it stores data row by row as plain text. Parquet is
columnar, it stores data column by column and also compresses it. This
matters for performance because if you only need a few columns, Parquet lets
Spark skip reading the columns you don't need, and the file size is much
smaller. I actually converted the Superstore CSV to Parquet and checked - CSV
was about 2.3 MB, Parquet was about 440 KB, so around 5x smaller.

Q5. Select product_id and price where category is Electronics

pythondf.filter(df.Category == "Technology").select("Product ID", "Sales")

Q6. Rename column and cast price to Double

pythondf.withColumnRenamed("old_name", "new_name") \
  .withColumn("price", F.col("price").cast("double"))

Q7. How Lineage Graph (DAG) gives fault tolerance
Spark remembers all the transformations that were used to build a DataFrame,
this is called lineage. If a worker node crashes and loses some data
partitions, Spark doesn't need to restart the whole job, it just recomputes
the lost partitions using the lineage information.

Q8. Filter status Completed AND amount > 1000

pythondf_orders.filter((df_orders.status == "Completed") & (df_orders.amount > 1000))

Q9. Predicate Pushdown in Parquet
Predicate pushdown means the filter condition is applied while reading the
file itself, not after loading everything into memory. Since Parquet stores
data with metadata (like min/max values per column chunk), Spark can skip
reading chunks that don't match the filter at all. This means less data
actually gets loaded into memory compared to reading everything first and
then filtering.

Q10. Add final_price column = base_price * 1.18

pythondf.withColumn("final_price", F.col("base_price") * 1.18)

Q11. Transformations vs Actions
Transformations are lazy, they just build up the plan and return a new
DataFrame, they don't run immediately. Examples: filter(), select().
Actions actually trigger the computation and return a real result. Examples:
count(), show(), collect().

Q12. Load Parquet, filter null user_id, save as CSV

pythondf = spark.read.parquet("path/to/input")
df_clean = df.filter(df.user_id.isNotNull())
df_clean.write.csv("path/to/output", header=True)

(Note: on my machine df.write.csv() gave an error because of missing
winutils.exe on Windows, so I actually saved it using collect() + Python's
csv module instead, same fix as Week 5.)

Q13. Client Mode vs Cluster Mode
In Client Mode, the driver runs on the machine you submitted the job from,
outside the cluster - so if your laptop disconnects, the job can fail. In
Cluster Mode, the driver runs inside the cluster itself, managed by the
cluster manager, so it's more reliable for production jobs.

Q14. Filter region North OR priority High

pythondf.filter((df.region == "North") | (df.priority == "High"))

Q15. Why .show(5) is safer than .collect() on huge datasets
.collect() brings back every single row from all the workers to the driver's
memory. On a multi-terabyte dataset this can easily crash the driver since it
doesn't have enough RAM. .show(5) only computes and displays a small number
of rows, so it's much safer to just explore/check the data without risking a
crash.



How to run


Same setup as Week 5 (Java 17, pip install pyspark)
Put Sample - Superstore.csv in the same folder as the notebook
Run all cells top to bottom