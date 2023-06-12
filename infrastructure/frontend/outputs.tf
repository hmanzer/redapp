#####
# Frontend
#####


output "codedeploy_deployment_group_name_frontend" {
  value = module.redapp_frontend.codedeploy_deployment_group_name_frontend
}


output "codedeploy_app_name_frontend" {
  value = module.redapp_frontend.codedeploy_app_name_frontend
}


output "elb_frontend_dns_name" {
  value = module.redapp_frontend.elb_frontend_dns_name
}


output "vpc_id" {
  value = module.redapp_vpc.vpc_id
}


#####
# S3 objects
#####
output "s3_frontend_artifacts_bucket_name" {
  value = module.redapp_frontend.s3_frontend_artifacts_bucket_name
}