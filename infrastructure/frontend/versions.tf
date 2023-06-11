provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }

  backend "s3" {
    encrypt        = true
    region         = "ap-southeast-1"
    bucket         = "terraform-tfstate-hmz-redapp"
    key            = "redapp-frontend.tfstate"
    dynamodb_table = "terraform-lock-hmz-redapp"
  }
}