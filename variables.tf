variable "cluster_name" {
  description = "Cluster name."
}
variable "tags" {
  description = "Tags."
  type        = map(string)
}
variable "vpc_id" {
  description = "ID of your VPC."
}
variable "trusted_cidr_blocks" {
  description = "Trusted subnets e.g. with ALB and bastion host."
  type        = list(string)
  default     = [""]
}
variable "capacity_providers" {
  description = "Amazon ECS cluster capacity providers determine the infrastructure to use for your tasks."
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

locals {
  vpc_id              = var.vpc_id
  name                = replace(var.cluster_name, " ", "_")
  capacity_providers  = var.capacity_providers
  trusted_cidr_blocks = var.trusted_cidr_blocks
  tags = merge({
    Name   = var.cluster_name,
    Module = "ECS Cluster"
  }, var.tags)
}