data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Name"
    values = ["dae-streamlit-vpc-subnet-public*"]
  }
}

output "public_subnets" {
  value = data.aws_subnets.public_subnets.ids
}

resource "aws_alb" "alb" {
  name            = "tf-dae-alb-streamlit"
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnets.public_subnets.ids
}

# HTTP Listener
resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }
}

########################################################################################################################
## Target Group for our service
########################################################################################################################

resource "aws_alb_target_group" "service_target_group" {
  name                 = "tf-dae-steramlit-tg"
  port                 = 8501
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 5
  target_type          = "ip"

  depends_on = [aws_alb.alb]
}

output "alb_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_alb.alb.name
}