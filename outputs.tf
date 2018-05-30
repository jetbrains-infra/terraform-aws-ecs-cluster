output "name" {
  value = "${aws_ecs_cluster.default.name}"
}
output "security_group" {
  value = "${aws_security_group.ecs_nodes.id}"
}