output "name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "ecs_service_role_name" {
  value = "${aws_iam_role.ecs_service_role.name}"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}

output "security_group" {
  value = "${aws_security_group.ecs_nodes.id}"
}

output "iam_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ecs_node.arn}"
}