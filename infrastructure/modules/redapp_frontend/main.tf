#####
# Local values a.k.a. deduced variables
#####
locals {
  project_name_with_env = format("%s-%s", var.environment, var.project_name)
}

locals {
  action_on_timeout = var.auto_traffic_rerouting == "true" ? "CONTINUE_DEPLOYMENT" : "STOP_DEPLOYMENT"
}