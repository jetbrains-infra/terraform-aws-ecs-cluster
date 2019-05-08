output "name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "ecs_service_role_name" {
  value = "${aws_iam_role.ecs_service_role.name}"
}

output "ecs_default_task_role_name" {
  value = "${aws_iam_role.ecs_task_role.name}"
}

output "iam_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ecs_node.arn}"
}

output "security_group_id" {
  value = "${aws_security_group.ecs_nodes.id}"
}