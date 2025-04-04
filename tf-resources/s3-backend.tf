terraform {
  backend "s3" {
    bucket         = "dae-terraform-state-bucket-v2"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}
