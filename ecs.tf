resource "aws_ecs_cluster" "default" {
  name = "${var.cluster_name}"
}