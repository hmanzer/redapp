variable "region" {
  default = "ap-southeast-1"
}

#####
# S3 backend bucket
#####
variable "bucket_name" {
  default = "terraform-tfstate-hmz-redapp"
}

variable "env" {
  default = "dev"
}
#####
# DynamoDB state locking
#####
variable "lock_table_name" {
  default = "terraform-lock-hmz-redapp"
}
