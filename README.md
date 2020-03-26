## About

Terraform module to run ECS cluster. 

## Usage

```hcl
module "example_ecs_cluster" {
  source              = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  project             = "FooBar"
  cluster_name        = "Example"
  vpc_id              = var.vpc_id
  capacity_providers  = ["FARGATE", aws_ecs_capacity_provider.example.name]
  
  // subnets with ALB and bastion host e.g..
  trusted_cidr_blocks = [
    aws_subnet.public_subnet_1.cidr_block,
    aws_subnet.public_subnet_2.cidr_block
  ]
}
```

Default values:
```hcl
module "example_ecs_cluster" {
  source                    = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name              = "Example"
  vpc_id                    = var.vpc_id
  capacity_providers        = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider = "FARGATE"
  trusted_cidr_blocks       = []
  tags = {
    "Project" = "example",
    "Version" = "0.1"  
  } 
}
```

## Outputs

* `name` - cluster name
* `id` - cluster id
* `arn` - cluster ARN
* `ecs_service_role_name` - ECS service role name
* `ecs_default_task_role_name` - ECS default task role name
* `iam_instance_profile_arn` - IAM instance profile ARN
* `iam_instance_profile_name` -  IAM instance profile name
* `iam_instance_role_name` - IAM instance role name
* `security_group_id` - security group id
* `security_group_name` - security group name