###############################################################################
#### Default values that match what is set in the datacenter terraform     ####
####  file.  These should not be changed here!  These should be set in the ####
####  <datacetner>_<datacenter_prefix>.tf file that is located in the      ####
####  datacenters/aws/ directory of the terraform modules.                 ####
###############################################################################
cloud_provider                = "aws"
aws_region                    = "us-east-2"
datacenter_prefix             = "oh"
machine_cidr_block            = "10.191.0.0/16"
private_subnet_cidrs          = ["10.191.1.0/24", "10.191.2.0/24", "10.191.3.0/24"]
public_subnet_cidrs           = ["10.191.101.0/24", "10.191.102.0/24", "10.191.103.0/24"]
host_prefix                   = "23"
instance_tenancy              = "default"
datacenter                    = "ohio"
aws_access_key                = "*******************"
aws_secret_key                = "*******************"
url                           = "https://api.openshift.com"
availability_zones            = ["us-east-2a", "us-east-2b", "us-east-2c"]
role_arn                      = "*******************"
session_name                  = "terraform_dev"
ocm_environment               = "integration"

################################################################################
#### These are the variables used to deploy ROSA                            ####
################################################################################
cluster_name                  = "dragon-isd-dev"
rosa_version                  = "4.13.4"
replicas                      = "3"
enable_private_link           = "false"
compute_node_instance_type    = "m5.xlarge"
offline_access_token          = "*******************"
htpasswd_username             = "*******************"
htpasswd_password             = "*******************"
