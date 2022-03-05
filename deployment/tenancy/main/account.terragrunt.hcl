locals {
  account_name   = "main"
  aws_account_id = get_env("AWS_ACCOUNT_ID")
  aws_profile    = "default"
}