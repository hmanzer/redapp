#####
# General
#####
variable "region" {
  type = string
}

#####
# VPC and subnet already created
#####
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "public_subnet_ids" {
  type = list(any)
}



#####
# ELB name
#####

variable "ssh_whitelist_ipv4" {
  type = list(string)
}

#####
# General project config
#####
variable "project_name" {
  type        = string
  description = "hmz-redapp-frontend"
}

variable "s3_frontend_artifacts_bucket_name" {
  type        = string
  description = "hmz-redapp-frontend"
}

variable "environment" {
  type        = string
  description = "dev"
}

variable "auto_traffic_rerouting" {
  type        = string
  description = "true"
  default     = "true"
}

variable "description_of_project" {
  type        = string
}

variable "key_name" {
  type        = string
}

variable "ami_image_id" {
  type = string
}

variable "instance_type_frontend" {
  type        = string
  description = "t3a.micro - #t3a.micro is too slow for frontend, ELB default timeout is 3 seconds. Had to switch to 20 seconds. Should be fine since we use CloudFront."
}


variable "init_flag" {
  type        = string
  description = "Is this the first time creating this project?? true or false"
}

variable "is_public" {
  type        = string
}