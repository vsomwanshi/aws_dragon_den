# Setup Security token's localy for the account roles created

data "aws_caller_identity" "current" {}

locals {
  sts_roles = {
    role_arn         = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Installer-Role",
    support_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Support-Role",
    instance_iam_roles = {
      master_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-ControlPlane-Role",
      worker_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ManagedOpenShift-Worker-Role"
    },
    operator_role_prefix = var.cluster_name,
  }
  tags = {
    "owner" = data.aws_caller_identity.current.arn
  }
}

# Module for the deployment of ROSA, it is depend's on VPC so it would deploy VPC first and initiate other components.

resource "rhcs_cluster_rosa_classic" "rosa" {
  name = var.cluster_name

  cloud_region   = var.aws_region
  aws_account_id = data.aws_caller_identity.current.account_id
  tags           = local.tags

  replicas             = var.replicas
  availability_zones   = var.availability_zones
  aws_private_link     = var.enable_private_link
  aws_subnet_ids       = var.enable_private_link ? module.rosa-vpc.private_subnets : concat(module.rosa-vpc.private_subnets, module.rosa-vpc.public_subnets)
  compute_machine_type = var.compute_node_instance_type
  multi_az             = length(module.rosa-vpc.private_subnets) == 3 ? true : false
  version              = var.rosa_version
  machine_cidr         = module.rosa-vpc.vpc_cidr_block
  properties           = { rosa_creator_arn = data.aws_caller_identity.current.arn }
  sts                  = var.enable_sts ? local.sts_roles : null
  depends_on           = [module.rosa-vpc]
}

data "rhcs_rosa_operator_roles" "operator_roles" {
  operator_role_prefix = var.cluster_name
  account_role_prefix  = var.cluster_name
}

# Module for the deployment of required operator roles

module "operator_roles" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.4"

  create_operator_roles = true
  create_oidc_provider  = true
  create_account_roles  = false

  cluster_id                  = rhcs_cluster_rosa_classic.rosa.id
  rh_oidc_provider_thumbprint = rhcs_cluster_rosa_classic.rosa.sts.thumbprint
  rh_oidc_provider_url        = rhcs_cluster_rosa_classic.rosa.sts.oidc_endpoint_url
  operator_roles_properties   = data.rhcs_rosa_operator_roles.operator_roles.operator_iam_roles
}

resource "rhcs_cluster_wait" "rosa" {
  cluster = rhcs_cluster_rosa_classic.rosa.id
  timeout = 60
}

# Module for the configuration of initial identity provider which is "htpasswd", there are multiple IDP's.

resource "rhcs_identity_provider" "rosa_iam_htpasswd" {
  cluster = rhcs_cluster_rosa_classic.rosa.id
  name    = "htpasswd"
  htpasswd = {
    username = var.htpasswd_username
    password = var.htpasswd_password
  }
  depends_on = [
    rhcs_cluster_wait.rosa
  ]
}

# Post IDP confoguration, it will create a local user kubeadmin and add in to "cluster-admins" group to provide admin access.
resource "rhcs_group_membership" "htpasswd_admin" {
  cluster = rhcs_cluster_rosa_classic.rosa.id
  group   = "cluster-admins"
  user    = var.htpasswd_username
  depends_on = [
    rhcs_cluster_wait.rosa
  ]
}

data "rhcs_policies" "all_policies" {}

# Module to deploy Account-wide IAM role and policies.
module "create_account_roles" {
  source  = "terraform-redhat/rosa-sts/aws"
  version = "0.0.10"

  create_operator_roles = false
  create_oidc_provider  = false
  create_account_roles  = true

  account_role_prefix    = var.cluster_name
  ocm_environment        = var.ocm_environment
  rosa_openshift_version = var.rosa_version
  account_role_policies  = data.rhcs_policies.all_policies.account_role_policies
  operator_role_policies = data.rhcs_policies.all_policies.operator_role_policies
}