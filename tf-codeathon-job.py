import sys
import boto3
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import to_date, col, when
from pyspark.sql.types import IntegerType, FloatType
import logging

# Logging setup
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s:%(name)s:%(message)s")

# Get job arguments
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'INPUT_S3_PATH', 'OUTPUT_S3_PATH'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Load data from S3
datasource0 = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    connection_options={"paths": [args['INPUT_S3_PATH']]},
    format="csv",
    format_options={"withHeader": True},
    transformation_ctx="datasource0"
)
df = datasource0.toDF()

# Standardize column names to lowercase
df_lower = df.select([col(c).alias(c.lower()) for c in df.columns])

# Rename specific columns
df_renamed = df_lower.withColumnRenamed("price per unit", "unit_price")
df_renamed = df_lower.withColumnRenamed("product category", "category")

# Convert 'date' column to datetime type
df_renamed = df_renamed.withColumn("date", to_date(col("date")))

# Drop irrelevant columns
df_renamed = df_renamed.drop("customer id", "transaction id")

# Categorize ages into meaningful groups
df_transformed = df_renamed.withColumn(
    "age group",
     when(col("age") < 18, "teen")
    .when((col("age") >= 18) & (col("age") < 30), "young_adult")
    .when((col("age") >= 30) & (col("age") <= 50), "adult")
    .otherwise("senior")
)

# Ensure numerical columns are properly typed
df_transformed = df_transformed.withColumn("quantity", col("quantity").cast(IntegerType()))
df_transformed = df_transformed.withColumn("unit_price", col("unit_price").cast(FloatType()))

# Calculate total amount spent per transaction
df_transformed = df_transformed.withColumn("total_amount", col("quantity") * col("unit_price"))

# Write to S3
# output_s3_path = "s3://codethon-bucket/processed/"
df_transformed.write.mode("overwrite").csv(args['OUTPUT_S3_PATH'], header=True)

# Commit Glue job
job.commit()
