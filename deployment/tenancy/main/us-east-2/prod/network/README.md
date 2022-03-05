# Output of vpc module
```
output "vpc_id" {
  value     = aws_vpc.main.id
  sensitive = false
}

output "subnet_publish" {
  value = aws_subnet.subnets_publish[*].id
}

output "subnets_private" {
  value = aws_subnet.subnets_private[*].id
}

output "publish_subnets_cidr_blocks" {
  value = aws_subnet.subnets_publish[*].cidr_block
}

output "private_subnets_cidr_blocks" {
  value = aws_subnet.subnets_private[*].cidr_block
}
```
# Usage
```
module "vpc" {
  source              = "./vpc"
  common_tags         = local.common_tags
  prefix              = local.prefix
  cidr_block          = "10.1.0.0/16"
  cidr_publish_subnet = ["10.1.1.0/24", "10.1.2.0/24"]
  cidr_private_subnet = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zone   = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]
  nat_gateway_enabled = false
}
```