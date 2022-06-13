module "example_ecs_cluster" {
  source       = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name = "FooBar"

  // subnets where the ECS nodes are hosted
  subnets_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}
