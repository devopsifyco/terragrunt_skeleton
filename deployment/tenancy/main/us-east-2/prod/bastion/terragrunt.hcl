locals {
  root_deployments_dir = get_parent_terragrunt_dir("common.terragrunt.hcl")
}

include "common" {
  path = find_in_parent_folders("common.terragrunt.hcl")
}

terraform {
  source = "${local.root_deployments_dir}/../modules/bastion"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../network"
  mock_outputs = {
    vpc_id         = "vpc-0b65210cb46184d23"
    subnet_publish = ["subnet-01ccd045746e8339b"]
  }
}

# LOCAL PARAMETERS
inputs = {
  key_name       = "quan"
  aws_key_pair   = "abc"
  vpc_id         = dependency.vpc.outputs.vpc_id
  subnet_publish = dependency.vpc.outputs.subnet_publish
}