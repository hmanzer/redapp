output "codedeploy_deployment_group_name_frontend" {
  value = aws_codedeploy_deployment_group.frontend.deployment_group_name
}

output "codedeploy_app_name_frontend" {
  value = aws_codedeploy_app.frontend.name
}

output "elb_frontend_dns_name" {
 value = aws_alb.frontend_alb.dns_name
}


#####
# S3 objects
#####
output "s3_frontend_artifacts_bucket_name" {
  value = aws_s3_bucket.s3_frontend_artifacts.id
}