output "cloudfront_certificate_validation_info" {
  value       = aws_acm_certificate.frontend.domain_validation_options
  description = "For now, manually create this DNS validation entry in Route53, because cross-AWS accounts validation is complicated"
}

output "chat_certificate_validation_info" {
  value       = aws_acm_certificate.chat.domain_validation_options
  description = "For now, manually create this DNS validation entry in Route53, because cross-AWS accounts validation is complicated"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "codedeploy_deployment_group_name_frontend" {
  value = aws_codedeploy_deployment_group.frontend.deployment_group_name
}

output "codedeploy_deployment_group_name_chat" {
  value = aws_codedeploy_deployment_group.chat.deployment_group_name
}

output "codedeploy_app_name_frontend" {
  value = aws_codedeploy_app.frontend.name
}

output "codedeploy_app_name_chat" {
  value = aws_codedeploy_app.chat.name
}

# output "elb_frontend_dns_name" {
#  value = aws_elb.frontend.dns_name
# }

# output "alb_chat_dns_name" {
#  value = aws_alb.chat_alb.dns_name
# }


#####
# S3 objects
#####
output "s3_frontend_artifacts_bucket_name" {
  value = aws_s3_bucket.s3_frontend_artifacts.id
}

output "s3_frontend_config_bucket_name" {
  value = aws_s3_bucket.s3_frontend_config.id
}
