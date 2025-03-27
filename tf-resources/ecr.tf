# Data source to retrieve the ecr repository
data "aws_ecr_repository" "ecr_repository" {
  name = "dae-codeathon-ecr"
}

# Data source to retrieve the latest image
data "aws_ecr_image" "latest_image" {
  repository_name = "dae-codeathon-ecr"
  most_recent     = true
}

# Output to display the latest ECR image URI
output "latest_ecr_image_uri" {
  value = "${data.aws_ecr_repository.ecr_repository.repository_url}@${data.aws_ecr_image.latest_image.image_digest}"
  #value       = "${data.aws_ecr_repository.ecr_repository.repository_url}:latest"
  description = "The URI of the most recent image in the ECR repository"
}