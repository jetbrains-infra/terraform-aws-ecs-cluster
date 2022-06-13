output "name" {
  value       = aws_ecs_cluster.default.name
  description = "Cluster name."
}

output "id" {
  value       = aws_ecs_cluster.default.id
  description = "Cluster ID."
}

output "ecs_service_role_name" {
  value       = aws_iam_role.ecs_service_role.name
  description = "ECS service role name."
}

output "ecs_service_role_arn" {
  value       = aws_iam_role.ecs_service_role.arn
  description = "ECS service role ARN."
}

output "ecs_default_task_role_name" {
  value       = aws_iam_role.ecs_task_role.name
  description = "ECS default task role name."
}

output "ecs_default_task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "ECS default task role ARN."
}

output "iam_instance_profile_arn" {
  value       = aws_iam_instance_profile.ecs_node.arn
  description = "IAM instance profile ARN."
}

output "iam_instance_profile_name" {
  value       = aws_iam_instance_profile.ecs_node.name
  description = "IAM instance profile name."
}

output "iam_instance_role_name" {
  value       = aws_iam_role.ec2_instance_role.name
  description = "IAM instance role name."
}

output "security_group_id" {
  value       = aws_security_group.ecs_nodes.id
  description = "The ID of the ECS nodes security group."
}

output "security_group_name" {
  value       = aws_security_group.ecs_nodes.name
  description = "The name of the ECS nodes security group."
}

output "arn" {
  value       = aws_ecs_cluster.default.arn
  description = "Cluster ARN."
}

output "capacity_provider_name" {
  value       = aws_ecs_capacity_provider.asg.name
  description = "capacity provider name (the same name for ASG)."
}
