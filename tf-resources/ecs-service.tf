data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["kaggle-data-vpc-subnet-private*"]
  }
}

output "private_subnets" {
  value = data.aws_subnets.private_subnets.ids
}

resource "aws_ecs_service" "ecs_service" {
  name            = "tf-dae-streamlit-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  #   depends_on      = [aws_iam_role_policy.foo]

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service_target_group.arn
    container_name   = "tf-dae-streamlit-container"
    container_port   = 8501
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_container_instance.id]
    subnets          = data.aws_subnets.private_subnets.ids
    assign_public_ip = false
  }

  depends_on = [aws_ecs_task_definition.ecs_task_def]
}