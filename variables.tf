variable "cluster_name" {
  description = "Cluster name."
}
variable "trusted_cidr_blocks" {
  description = "Trusted subnets e.g. with ALB and bastion host."
  type        = list(string)
  default     = [""]
}
variable "instance_types" {
  description = "ECS node instance types. Maps of pairs like `type = weight`. Where weight gives the instance type a proportional weight to other instance types."
  type        = map(any)
  default = {
    "t3a.small" = 2
  }
}
variable "protect_from_scale_in" {
  description = "The autoscaling group will not select instances with this setting for termination during scale in events."
  default     = true
}
variable "asg_min_size" {
  description = "The minimum size the auto scaling group (measured in e2 instances)."
  default     = 0
}
variable "asg_max_size" {
  description = "The maximum size the auto scaling group (measured in e2 instances)."
  default     = 100
}
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}
data "aws_ssm_parameter" "ecs_ami_arm64" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id"
}
variable "spot" {
  description = "Choose should we use spot instances or on-demand to populate ECS cluster."
  type        = bool
  default     = false
}
variable "security_group_ids" {
  description = "Additional security group IDs. Default security group would be merged with the provided list."
  default     = []
}
variable "subnets_ids" {
  description = "IDs of subnets. Use subnets from various availability zones to make the cluster more reliable."
  type        = list(string)
}
variable "target_capacity" {
  description = "The target utilization for the cluster. A number between 1 and 100."
  default     = "100"
}
variable "user_data" {
  description = "A shell script will be executed at once at EC2 instance start."
  default     = ""
}
//noinspection TFIncorrectVariableType
variable "ebs_disks" {
  description = "A list of additional EBS disks."
  type        = map(string)
  default     = {}
}
data "aws_subnet" "default" {
  id = local.subnets_ids[0]
}
variable "on_demand_base_capacity" {
  description = "The minimum number of on-demand EC2 instances"
  default     = 0
}
variable "lifecycle_hooks" {
  description = "A list of maps containing the name,lifecycle_transition,default_result,heartbeat_timeout,role_arn,notification_target_arn keys"
  type = list(object({
    name                    = string
    lifecycle_transition    = string
    default_result          = string
    heartbeat_timeout       = number
    role_arn                = string
    notification_target_arn = string
    notification_metadata   = string
  }))
  default = []
}
variable "arm64" {
  description = "ECS node architecture"
  default     = false
  type        = bool
}

locals {
  ami_id                  = var.arm64 ? data.aws_ssm_parameter.ecs_ami_arm64.value : data.aws_ssm_parameter.ecs_ami.value
  asg_max_size            = var.asg_max_size
  asg_min_size            = var.asg_min_size
  ebs_disks               = var.ebs_disks
  instance_types          = var.instance_types
  lifecycle_hooks         = var.lifecycle_hooks
  name                    = replace(var.cluster_name, " ", "_")
  on_demand_base_capacity = var.on_demand_base_capacity
  protect_from_scale_in   = var.protect_from_scale_in
  sg_ids                  = distinct(concat(var.security_group_ids, [aws_security_group.ecs_nodes.id]))
  spot                    = var.spot == true ? 0 : 100
  subnets_ids             = var.subnets_ids
  target_capacity         = var.target_capacity
  trusted_cidr_blocks     = var.trusted_cidr_blocks
  user_data               = var.user_data == "" ? [] : [var.user_data]
  vpc_id                  = data.aws_subnet.default.vpc_id

  tags = {
    Name   = var.cluster_name,
    Module = "ECS Cluster"
  }
}
