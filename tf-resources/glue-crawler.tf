resource "aws_glue_crawler" "codeathon_crawler" {
  database_name = aws_glue_catalog_database.codeathon_catalog_db.name
  name          = "tf-glue-crawler"
  role          = data.aws_iam_role.tf_glue_job_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.bucket-data.bucket}/processed/"
  }

  depends_on = [aws_s3_bucket.bucket-data, aws_glue_catalog_database.codeathon_catalog_db]
}

resource "null_resource" "start_glue_crawler" {
  provisioner "local-exec" {
    command = "aws glue start-crawler --name ${aws_glue_crawler.codeathon_crawler.name}"
  }

  depends_on = [aws_glue_crawler.codeathon_crawler]
}

resource "null_resource" "wait_for_glue_tables" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Glue tables to be registered..."
      for i in {1..10}; do
        TABLE_COUNT=$(aws glue get-tables --database-name ${aws_glue_catalog_database.codeathon_catalog_db.name} --query 'TableList | length(@)')
        if [ "$TABLE_COUNT" -gt 0 ]; then
          echo "Tables found in Glue. Proceeding..."
          exit 0
        fi
        echo "No tables found yet. Retrying in 30 seconds..."
        sleep 180
      done
      echo "Error: Tables were not registered in Glue within the expected time."
      exit 1
    EOT
  }

  depends_on = [null_resource.start_glue_crawler]
}