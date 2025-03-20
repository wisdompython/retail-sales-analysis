resource "aws_ecs_cluster" "ecs_cluster" {
  name = "tf-ecs-cluster"

#   depends_on = [aws_ecs_service.ecs_service]
}