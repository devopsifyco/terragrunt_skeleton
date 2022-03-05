variable "prefix" {
  type = string
  description = "prefix name"
}
variable "common_tags" {
  type        = map
  description = "tag commons"
}
variable "key_name" {
  type = string
  description = "ssh key"  
}
variable "aws_key_pair" {
  type = string
  description = "ssh key"
}
variable "vpc_id" {
  type        = string
  description = "output of vpc module"  
}
variable "subnet_publish" {
  type        = list(string)
  description = "output of vpc module"
}
