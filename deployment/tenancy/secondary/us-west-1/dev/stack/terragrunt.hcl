include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply"]

    arguments = [
      "-var-file=./app/terraform.tfvars",
      "-var-file=./bastion/terraform.tfvars",
      "-var-file=./db/terraform.tfvars",
      "-var-file=./route53/terraform.tfvars",
      "-var-file=./vpc/terraform.tfvars"
    ]
  }
}