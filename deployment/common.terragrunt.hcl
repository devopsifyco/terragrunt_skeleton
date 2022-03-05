locals {
  account      = read_terragrunt_config(find_in_parent_folders("account.terragrunt.hcl"))
  region       = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
  environment  = read_terragrunt_config(find_in_parent_folders("environment.terragrunt.hcl"))

  prefix       = "demo"
}

# Create bucket store state file
remote_state {
  backend = "s3"
  disable_dependency_optimization = true
  config = {
    encrypt         = true
    region          = local.region.locals.aws_region
    bucket          = "${local.prefix}-${local.account.locals.aws_account_id}-${local.region.locals.aws_region}-${local.environment.locals.env}-terraform-state"
    key             = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table  = "${local.prefix}-${local.account.locals.aws_account_id}-${local.region.locals.aws_region}-${local.environment.locals.env}-terraform-locks"
  }
}

# Generate an backend block
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

# Generate an AWS required providers block
generate "required_providers" {
  path      = "required_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 2.54.0"
    }
  }
}
EOF
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region.locals.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account.locals.aws_account_id}"]
}
EOF
}

# GLOBAL PARAMETERS
inputs = {
  prefix = "${local.prefix}"
  common_tags = {
        Project     = "demo-terragrunt"
        Owner       = "quan"
        ManagedBy   = "Terragrunt"
        contact     = "quan@opsify.dev"
  }
}