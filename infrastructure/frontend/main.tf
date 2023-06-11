module "redapp_vpc" {
  source                      = "../modules/redapp_vpc"
  region                      = "ap-southeast-1"
  environment                 = var.environment
  vpc_name                    = "redapp_vpc"
  vpc_cidr_block              = "172.31.0.0/16"
  public_availability_zone_1  = "ap-southeast-1a"
  private_availability_zone_1 = "ap-southeast-1a"
  public_subnet_1             = "172.31.1.0/24"
  private_subnet_1            = "172.31.3.0/24"
}


module "redapp_frontend" {
  source                            = "../modules/redapp_frontend"
  region                            = "ap-southeast-1"
  vpc_id                            = module.redapp_vpc.vpc_id
  private_subnet_ids                = [module.redapp_vpc.private_subnet_1_id]
  public_subnet_ids                 = [module.redapp_vpc.public_subnet_1_id]
  ssh_whitelist_ipv4                = ["202.185.236.177/32"]   #myip                                                                                                                 # List of IPs to be whitelisted for SSH access, default Dynasty VPN
  project_name                      = "hmz-redapp"                                                                                                                    # be as short and clear as possible
  s3_frontend_artifacts_bucket_name = "hmz-redapp-frontend"
  environment                       = var.environment
  auto_traffic_rerouting            = "true"
  description_of_project            = "redapp simple website"
  key_name                          = "devops-sg"
  ami_image_id                      = "ami-0df7a207adb9748c7" # Debian 10 hardened
  instance_type_frontend            = "t3a.small"
  init_flag                         = "true"          #First time?
  is_public                         = "true"
}