#####
# Security group for ELB
#####
resource "aws_security_group" "frontend_alb" {
  name   = format("%s-%s", local.project_name_with_env, "alb")
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Outside Traffic"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-%s", local.project_name_with_env, "alb")
  }
}



#####
# AWS ALB
#####
resource "aws_alb" "frontend_alb" {
  name               = "${var.project_name}-frontend"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids
  security_groups    = [aws_security_group.frontend_alb.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Environment = var.environment
  }
}


resource "aws_lb_target_group" "frontend_alb" {
  name                 = "${var.project_name}-frontend"
  port                 = 8080
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = 30 

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.project_name}-frontent-lb-tg"
    Environment = var.environment
  }
}

resource "aws_autoscaling_attachment" "frontent_alb" {
  count                  = var.init_flag ? 1 : 0
  autoscaling_group_name = var.init_flag ? aws_autoscaling_group.frontend[0].name : ""
  lb_target_group_arn    = aws_lb_target_group.frontend_alb.arn
}

resource "aws_lb_listener" "frontend_listener_redirect" {
  load_balancer_arn = aws_alb.frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_alb.id
  }
}