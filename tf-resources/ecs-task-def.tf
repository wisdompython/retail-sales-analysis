data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "tf-task-definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = "tf-retail-analysis-data"
      image = "${data.aws_ecr_repository.ecr_repository.repository_url}:latest"
    #   image     = "${data.aws_ecr_repository.ecr_repository.repository_url}@${data.aws_ecr_image.latest_image.image_digest}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8501
          hostPort      = 8501
        }
      ]
    }
  ])
}