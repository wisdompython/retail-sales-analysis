data "aws_iam_role" "tf_user_role" {
  name = "daengineer"
}

locals {
  lakeformation_roles = {
    "glue_access_role"      = data.aws_iam_role.tf_glue_job_role.arn
    "data_engineering_role" = data.aws_iam_role.tf_user_role.arn
    "ecs-streamlit_role"    = data.aws_iam_role.ecs_task_role.arn
  }
}

resource "aws_glue_catalog_database" "codeathon_catalog_db" {
  name = "kaggle-data"
}

# Grant Lake Formation permissions to principals in Glue database
resource "aws_lakeformation_permissions" "glue_db_lf_access" {
  for_each                      = local.lakeformation_roles
  principal                     = each.value
  permissions                   = ["ALL"]
  permissions_with_grant_option = ["ALL"]

  database {
    name = aws_glue_catalog_database.codeathon_catalog_db.name
  }

  depends_on = [aws_glue_catalog_database.codeathon_catalog_db]
}

# resource "null_resource" "delay_after_table_creation" {
#   provisioner "local-exec" {
#     command = "sleep 120"  # Wait for 120 seconds for table to sync in lakeformation
#   }

#   depends_on = [null_resource.wait_for_glue_tables]
# }

# Grant permissions to all tables in the Glue database
resource "aws_lakeformation_permissions" "table_permissions_all" {
  for_each                      = local.lakeformation_roles
  principal                     = each.value
  permissions                   = ["ALL"]
  permissions_with_grant_option = ["ALL"]

  table {
    database_name = aws_glue_catalog_database.codeathon_catalog_db.name
    # name = "*"
    wildcard = true # Applies to all tables in the database
  }

  # depends_on = [null_resource.delay_after_table_creation]
}


output "tf_lakeformation_roles" {
  value = [data.aws_iam_role.tf_glue_job_role.arn, data.aws_iam_role.tf_user_role.arn]
}