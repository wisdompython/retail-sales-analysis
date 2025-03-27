terraform {
  backend "s3" {
    bucket = "dae-codeathon-tfstatefile"
    key    = "dae-streamlit-dev"
    region = "us-east-1"

    use_lockfile = true
  }
}
