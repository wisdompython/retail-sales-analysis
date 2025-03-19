terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.91"
    }
  }
   backend "s3" {
    bucket         = "dae-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}