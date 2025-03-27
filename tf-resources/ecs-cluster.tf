resource "aws_ecs_cluster" "ecs_cluster" {
  name = "tf-dae-streamlit-cluster"

  #   depends_on = [aws_ecs_service.ecs_service]
}