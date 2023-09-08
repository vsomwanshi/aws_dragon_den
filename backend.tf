################################################################################
#### Terraform backend is set to S3 bucket, below is the configuration      ####
################################################################################

terraform {
  backend "s3" {
    encrypt        = true
    skip_credentials_validation = true
    skip_region_validation = true
    skip_metadata_api_check = true 
    bucket         = "rosa-terraform-state-files"
    key            = "state/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "rosa-terraform-statefile-locks"
  }
}

################################################################################
#### below is the sample configuration to set terraform backend as local    ####
################################################################################

/*
terraform { 
    backend "local" { } 
}
*/