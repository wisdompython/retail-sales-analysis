resource "aws_s3_bucket" "bucket-data" {
  bucket        = "tf-sales-analysis-data"
  force_destroy = true

  tags = {
    Name        = "Sales Analysis Data"
    Environment = "Dev"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket-data.bucket
}
