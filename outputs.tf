output "name" {
  value = "${aws_ecs_cluster.default.name}"
}

output "ecs_service_role_name" {
  value = "${aws_iam_role.ecs_service_role.name}"
}

output "cluster_id" {
  value = "${aws_ecs_cluster.default.id}"
}