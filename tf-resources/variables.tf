variable "kaggle_username" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
}

variable "kaggle_key" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
}

variable "vpc_id" {
  description = "ID of the existing VPC network - dae-streamlit-vpc"
  default     = "vpc-07fa9490c2fc36a95"
  type        = string
}