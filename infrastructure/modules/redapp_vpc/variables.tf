#####
# General
#####
variable "region" {
  type = string
}

variable "environment" {
  type        = string
  description = "dev"
}


#####
# VPC
#####
variable "vpc_name" {
  type        = string
  description = "redapp-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "172.31.0.0/16"
}

variable "public_availability_zone_1" {
  type        = string
  description = "ap-southeast-1a"
}

# variable "public_availability_zone_2" {
#   type        = string
#   description = "ap-southeast-1b"
# }

variable "private_availability_zone_1" {
  type        = string
  description = "ap-southeast-1a"
}

# variable "private_availability_zone_2" {
#   type        = string
#   description = "ap-southeast-1b"
# }

#####
# Public subnets
#####

variable "public_subnet_1" {
  type        = string
  description = "172.31.1.0/24"
}

# variable "public_subnet_2" {
#   type        = string
#   description = "172.31.2.0/24"
# }

#####
# Private subnets
#####
variable "private_subnet_1" {
  type        = string
  description = "172.31.3.0/24"
}