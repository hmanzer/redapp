#####
# Security group for EC2 instances
#####
resource "aws_security_group" "frontend_ec2" {
  name   = format("%s-%s", local.project_name_with_env, "ec2")
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.ssh_whitelist_ipv4
    description = "ALL TCP"
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_alb.id]
    description     = "for ELB to connect to frontend port"
  }

  #TEST
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "for ELB to connect to frontend port"
  }


  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-%s", local.project_name_with_env, "ec2")
  }
}



#####
# Launch config and ASG for CodeDeploy ASG
#####
resource "aws_launch_configuration" "frontend" {
  name_prefix     = local.project_name_with_env
  image_id        = var.ami_image_id
  instance_type   = var.instance_type_frontend
  security_groups = [aws_security_group.frontend_ec2.id]

  key_name = var.key_name

  iam_instance_profile = aws_iam_instance_profile.frontend_instance_profile.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_template" "frontend" {
  name_prefix = local.project_name_with_env
  image_id = var.ami_image_id
  instance_type = var.instance_type_frontend

  vpc_security_group_ids = [aws_security_group.frontend_ec2.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.frontend_instance_profile.name
  }

  user_data = filebase64("${path.module}/text/userdata.sh")
}

resource "aws_autoscaling_group" "frontend" {
  count                = var.init_flag ? 1 : 0
  max_size             = 2
  min_size             = 1
  # launch_configuration = aws_launch_configuration.frontend.name
  launch_template {
    id      = aws_launch_template.frontend.id
    version = aws_launch_template.frontend.default_version
  }
  vpc_zone_identifier  = var.is_public ? var.public_subnet_ids : var.private_subnet_ids
}


#####
# Code Deploy resources
#####
resource "aws_codedeploy_app" "frontend" {
  name             = local.project_name_with_env
  compute_platform = "Server"
}


resource "aws_codedeploy_deployment_config" "frontend" {
  deployment_config_name = local.project_name_with_env
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "frontend" {
  app_name              = aws_codedeploy_app.frontend.name
  deployment_group_name = local.project_name_with_env
  service_role_arn      = aws_iam_role.frontend_codedeploy_role.arn


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.frontend_alb.name
    }
  }


  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = local.action_on_timeout
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = "1"
    }
  }
  autoscaling_groups = [var.init_flag ? aws_autoscaling_group.frontend[0].id : ""]

  lifecycle {
    ignore_changes = [autoscaling_groups]
  }

}

