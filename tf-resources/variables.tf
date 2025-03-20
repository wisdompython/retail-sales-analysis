variable "kaggle_username" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
}

variable "kaggle_key" {
  type      = string
  sensitive = true # Mark as sensitive to avoid logging
}

variable "vpc_id" {
  description = "ID of the existing VPC network - kaggle-data-vpc"
  default     = "vpc-022ef429af1c28b08"
  type        = string
}