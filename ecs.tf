resource "aws_ecs_cluster" "default" {
  name               = local.name
  capacity_providers = local.capacity_providers
  tags               = local.tags

  default_capacity_provider_strategy {
    capacity_provider = local.capacity_provider
  }
}