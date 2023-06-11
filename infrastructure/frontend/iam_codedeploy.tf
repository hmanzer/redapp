#####
# IAM role for
#####
resource "aws_iam_user" "hmz_jenkins_codedeploy_user" {
  name = "hmz-jenkins-codedeploy-user"
  path = "/"

  tags = {
    "tag-key" = "bbpipeline-AWS_ACCESS_KEY_ID"
  }
}

data "aws_iam_policy_document" "hmz_jenkins_codedeploy_user" {
  statement {
    sid = "1"
    actions = [
      "codedeploy:*"
    ]

    resources = [
      "arn:aws:codedeploy:ap-southeast-1::*"
    ]
  }

  statement {
    sid = "HMZJenkinsPipelineCodeDeploy"
    actions = [
      "s3:*"
    ]
    resources = [
      format("%s%s%s", "arn:aws:s3:::", module.redapp_frontend.s3_frontend_artifacts_bucket_name, "/*"),
    ]
  }

}
resource "aws_iam_policy" "hmz_jenkins_codedeploy_user" {
  name   = "hmz-jenkins-codedeploy-user"
  path   = "/"
  policy = data.aws_iam_policy_document.hmz_jenkins_codedeploy_user.json
}

resource "aws_iam_user_policy_attachment" "hmz_jenkins_codedeploy_user" {
  user       = aws_iam_user.hmz_jenkins_codedeploy_user.name
  policy_arn = aws_iam_policy.hmz_jenkins_codedeploy_user.arn
}