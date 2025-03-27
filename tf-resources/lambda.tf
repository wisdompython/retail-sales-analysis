data "aws_iam_role" "tf_lambda_role" {
  name = "tf-retail-sales-analysis"
}

# Automate installation of dependencies with local-exec
# resource "null_resource" "install_dependencies" {
#   provisioner "local-exec" {
#     working_dir = "../"
#     command     = "bash lambda_layer.sh"
#   }
# }

# Create a ZIP file for the Lambda Layer
# data "archive_file" "lambda_layer" {
#   type        = "zip"
#   source_dir  = "../python" # Directory containing the installed dependencies
#   output_path = "../lambda_layer.zip"

#   depends_on = [null_resource.install_dependencies]
# }

data "aws_s3_object" "lambda_layer" {
  bucket = "dae-lambda-layer-bucket"
  key    = "retail_lambda_layer.zip"
}

# Create the Lambda Layer
resource "aws_lambda_layer_version" "requests_layer" {
  layer_name        = "requests-layer"
  s3_bucket         = data.aws_s3_object.lambda_layer.bucket
  s3_key            = data.aws_s3_object.lambda_layer.key
  s3_object_version = data.aws_s3_object.lambda_layer.version_id
  # filename            = data.archive_file.lambda_layer.output_path
  compatible_runtimes = ["python3.12"] # Specify compatible runtimes
}

# Create a ZIP file for the Lambda
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "../lambda_function.py"
  output_path = "../lambda_function_payload.zip"
}

resource "aws_lambda_function" "tf_kaggle_lambda" {
  filename      = data.archive_file.lambda.output_path
  function_name = "tf_dae_streamlit"
  role          = data.aws_iam_role.tf_lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 600
  runtime       = "python3.12"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  layers = [aws_lambda_layer_version.requests_layer.arn]

  environment {
    variables = {
      KAGGLE_USERNAME       = var.kaggle_username # Replace with your Kaggle username
      KAGGLE_KEY            = var.kaggle_key      # Replace with your Kaggle API key
      S3_BUCKET_NAME        = aws_s3_bucket.bucket-data.bucket
      GLUE_JOB_TRIGGER_NAME = aws_glue_trigger.trigger_glue_job.name
    }
  }
}

resource "aws_lambda_invocation" "tf_kaggle_lambda_invoke" {
  function_name = aws_lambda_function.tf_kaggle_lambda.function_name

  input = jsonencode({})

  depends_on = [aws_glue_trigger.trigger_glue_job]
}