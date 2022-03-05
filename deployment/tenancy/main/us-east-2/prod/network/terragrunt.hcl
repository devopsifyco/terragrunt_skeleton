locals {
  region = read_terragrunt_config(find_in_parent_folders("region.terragrunt.hcl"))
}

include "common" {
  path = find_in_parent_folders("common.terragrunt.hcl")
}

include "module_aws_vpc" {
  path = "${dirname(find_in_parent_folders("common.terragrunt.hcl"))}/../modules/vpc/vpc.hcl"
  #    .  equivalent to get_parent_terragrunt_dir()       .         .         .           .   
}

# LOCAL PARAMETERS
inputs = {
  cidr_block          = "10.1.0.0/16"
  cidr_publish_subnet = ["10.1.1.0/24", "10.1.2.0/24"]
  cidr_private_subnet = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zone   = ["${local.region.locals.aws_region}a", "${local.region.locals.aws_region}b"]
  nat_gateway_enabled = false
}