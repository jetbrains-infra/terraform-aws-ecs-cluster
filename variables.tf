variable "cluster_name" {
  description = "Cluster name. Should not contain spaces and special characters."
}

variable "cluster_subnets" {
  type = "list"
}

variable "trusted_cidr_blocks" {
  type    = "list"
  default = [""]
}

variable "root_partition_size" {
  default = 20
}

variable "docker_partition_size" {
  default = 50
}

variable "instance_type" {
  description = "The size of EC2 instance to launch"
  default     = "m5.large"
}

variable "ssh_key_name" {
  description = "The key name that should be used for the instance"
}

variable "desired_capacity" {
  description = "The maximum size of the auto scale group. Default 3."
  default     = "3"
}

// TODO scaling feature

//variable "minimum_capacity" {
//  description = "The minimum size of the auto scale group. Default 2."
//  default     = "2"
//}

//variable "maximum_capacity" {
//  description = "The maximum size of the auto scale group. Default 5."
//  default     = "5"
//}

data "aws_subnet" "default" {
  id = "${var.cluster_subnets[0]}"
}

locals {
  vpc_id = "${data.aws_subnet.default.vpc_id}"
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  owners = ["amazon"]
}