terraform {
  backend "s3" {
    bucket = "codeathon-streamlit-statefile"
    key    = "retail-sales-analysis-dev"
    region = "us-east-1"

    dynamodb_table = "tf-lock-codeathon-streamlit"
  }
}
