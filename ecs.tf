resource "aws_ecs_cluster" "default" {
  name = "${local.name}"

  tags {
    Project = "${local.project}"
  }
}