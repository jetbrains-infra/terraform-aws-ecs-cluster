resource "aws_ecs_cluster" "default" {
  name               = local.name
  tags = local.tags
}