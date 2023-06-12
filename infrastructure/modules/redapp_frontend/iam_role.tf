#####
# EC2 instance profile IAM Role
#####
resource "aws_iam_role" "frontend_ec2_cd_s3_instance_role" {
  name = format("%s_%s", var.project_name, "ec2_codedeploy_s3_role")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = format("%s_%s", var.project_name, "ec2_codedeploy_s3_role")
  }

}


resource "aws_iam_role_policy_attachment" "ec2_fullaccess_attach" {
  role       = aws_iam_role.frontend_ec2_cd_s3_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_role_policy_attachment" "ec2_s3fullaccess_attach" {
  role       = aws_iam_role.frontend_ec2_cd_s3_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# For SSM Session manager to work
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.frontend_ec2_cd_s3_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_patch" {
  role       = aws_iam_role.frontend_ec2_cd_s3_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}



resource "aws_iam_instance_profile" "frontend_instance_profile" {
  name = format("%s_%s", var.project_name, "ec2_codedeploy_s3_role")
  role = aws_iam_role.frontend_ec2_cd_s3_instance_role.name
}

#####
# AWS Code Deploy IAM role
#####
resource "aws_iam_role" "frontend_codedeploy_role" {
  name = format("%s_%s", var.project_name, "_code_deploy_service_role")

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name = format("%s_%s", var.project_name, "_code_deploy_service_role")
  }

}

resource "aws_iam_role_policy_attachment" "codedeploy_attach" {
  role       = aws_iam_role.frontend_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

data "aws_iam_policy_document" "codedeploy_attach_policy" {
  statement {
    sid = "1"
    actions = [
      "iam:PassRole",
      "ec2:RunInstances",
      "ec2:CreateTags"
    ]

    resources = [
      "*"
    ]
  }

}
resource "aws_iam_policy" "codedeploy_attach_role" {
  name   = "codedeploy-additional-role"
  path   = "/"
  policy = data.aws_iam_policy_document.codedeploy_attach_policy.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_attach2" {
  role       = aws_iam_role.frontend_codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_attach_role.arn
}