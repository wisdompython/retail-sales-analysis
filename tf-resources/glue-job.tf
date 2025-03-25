data "aws_iam_role" "tf_glue_job_role" {
  name = "tf-glue-job-access"
}

data "aws_s3_bucket" "glue_bucket" {
  bucket = "aws-glue-assets-kaggle-data" #use this predefined aws glue_bucket
}

# Upload the PySpark script to S3
resource "aws_s3_object" "glue_script" {
  bucket = data.aws_s3_bucket.glue_bucket.bucket
  key    = "scripts/tf-codeathon-job.py" # S3 key for the script
  source = "../tf-codeathon-job.py"      # Path to the local script file
}


# Glue Job
resource "aws_glue_job" "codeathon_job" {
  name         = "tf-dae-codeathon-job"
  role_arn     = data.aws_iam_role.tf_glue_job_role.arn # attach a role for Glue
  glue_version = "5.0"
  command {
    script_location = "s3://${aws_s3_object.glue_script.bucket}/${aws_s3_object.glue_script.key}" # add your Glue script location
  }

  default_arguments = {
    "--INPUT_S3_PATH"  = "s3://${aws_s3_bucket.bucket-data.bucket}/raw"
    "--OUTPUT_S3_PATH" = "s3://${aws_s3_bucket.bucket-data.bucket}/processed/"
  }
}

resource "aws_glue_trigger" "trigger_glue_job" {
  name    = "trigger-glue-job"
  type    = "ON_DEMAND"
  enabled = true

  actions {
    job_name = aws_glue_job.codeathon_job.name
  }
}