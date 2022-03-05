# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name   = "secondary"
  aws_account_id = "729713917879"
  aws_profile    = "default"
}