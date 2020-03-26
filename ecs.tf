resource "aws_ecs_cluster" "default" {
  name               = local.name
  capacity_providers = local.capacity_providers
  tags               = local.tags
}