########################################################################################################################
## SG for ECS Container Instances
########################################################################################################################

resource "aws_security_group" "ecs_container_instance" {
  name        = "tf-dae-ecs-sg"
  description = "Allow public internet access to ECS container on port 8501"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ingress" {
  description                  = "Allow ingress traffic from ALB on HTTP only"
  security_group_id            = aws_security_group.ecs_container_instance.id
  from_port                    = 8501
  to_port                      = 8501
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  description       = "Allow all egress traffic"
  security_group_id = aws_security_group.ecs_container_instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

########################################################################################################################
## SG for ALB
########################################################################################################################

resource "aws_security_group" "alb" {
  name        = "tf-dae-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress" {
  description       = "Allow public access to fargate ECS"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  description       = "Allow all egress traffic"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}