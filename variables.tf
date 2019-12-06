variable "cluster_name" {
  description = "Cluster name."
}

variable "project" {
  description = "Project tag"
}

variable "vpc_id" {
  description = "ID of your VPC."
}

variable "trusted_cidr_blocks" {
  type    = list(string)
  default = [""]
}

locals {
  vpc_id  = var.vpc_id
  project = var.project
  name    = replace(var.cluster_name, " ", "_")
}