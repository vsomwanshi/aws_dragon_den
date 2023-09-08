# Required variable information for the ROSA cluster deployment.

variable "aws_region" {
  type    = string
  default = ""
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type        = string
  description = "The name of the ROSA cluster to create"
  default     = ""
}

variable "rosa_version" {
  type        = string
  description = "The version of ROSA to be deployed"
  default     = ""
}

variable "compute_node_instance_type" {
  type        = string
  description = "The EC2 instance type to use for compute nodes"
  default     = ""
}

variable "host_prefix" {
  type        = string
  description = "The subnet mask to assign to each compute node in the cluster"
  default     = ""
}

variable "offline_access_token" {
  type        = string
  description = "The OCM API access token for your account"
  default     = ""
}

variable "availability_zones" {
  type        = list(any)
  description = "The availability zones to use for the cluster"
  default     = []
}

variable "machine_cidr_block" {
  type        = string
  description = "value of the CIDR block to use for the VPC"
  default     = ""
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "The CIDR blocks to use for the private subnets"
  default     = []
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "The CIDR blocks to use for the public subnets"
  default     = []
}

# when there is requirement of deploying private cluster then enable enable_private_link and set the default value to true

variable "enable_private_link" {
  type        = string
  description = "This enables private link and deploy private cluster"
  default     = ""
}

variable "enable_sts" {
  type        = bool
  description = "This enables STS"
  default     = true
}

variable "htpasswd_username" {
  type        = string
  description = "htpasswd username"
  default     = "kubeadmin"
}

variable "htpasswd_password" {
  type        = string
  description = "htpasswd password"
#  sensitive   = true
  default     = ""
}

variable "url" {
  type        = string
  description = "Provide OCM environment by setting a value to url"
  default     = ""
}

variable "ocm_environment" {
  type    = string
  default = ""
}

variable "role_arn" {
  type    = string
  default = ""
}

variable "session_name" {
  type    = string
  default = ""
}

variable "replicas" {
  type        = string
  description = "The number of computer nodes to create. Must be a minimum of 2 for a single-AZ cluster, 3 for multi-AZ."
  default     = ""
}