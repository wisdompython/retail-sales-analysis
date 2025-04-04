variable "kaggle_username" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
  default = "wisdomabiolaidris"
}

variable "kaggle_key" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
  default = "10185880d60f1d2757e94a7752a29155"
}

variable "vpc_id" {
  description = "ID of the existing VPC network - dae-streamlit-vpc"
  default     = "vpc-07fa9490c2fc36a95"
  type        = string
}