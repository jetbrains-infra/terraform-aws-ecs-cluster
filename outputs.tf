output "name" {
  value = aws_ecs_cluster.default.name
}

output "id" {
  value = aws_ecs_cluster.default.id
}

output "ecs_service_role_name" {
  value = aws_iam_role.ecs_service_role.name
}

output "ecs_service_role_arn" {
  value = aws_iam_role.ecs_service_role.arn
}

output "ecs_default_task_role_name" {
  value = aws_iam_role.ecs_task_role.name
}

output "ecs_default_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "iam_instance_profile_arn" {
  value = aws_iam_instance_profile.ecs_node.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ecs_node.name
}

output "security_group_id" {
  value = aws_security_group.ecs_nodes.id
}

output "security_group_name" {
  value = aws_security_group.ecs_nodes.name
}

output "iam_instance_role_name" {
  value = aws_iam_role.ec2_instance_role.name
}

output "arn" {
  value = aws_ecs_cluster.default.arn
}

output "capacity_provider_name" {
  value = aws_ecs_capacity_provider.asg.name
}
