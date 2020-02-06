## About

Terraform module to run ECS cluster. 

## Usage

```hcl
module "example_ecs_cluster" {
  source              = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  project             = "FooBar"
  cluster_name        = "Example"
  vpc_id              = var.vpc_id
  
  // subnets with ALB and bastion host e.g..
  trusted_cidr_blocks = [
    aws_subnet.public_subnet_1.cidr_block,
    aws_subnet.public_subnet_2.cidr_block
  ]
}
```

## Outputs

* `name` - cluster name
* `id` - cluster id
* `ecs_service_role_name` - ECS service role name
* `ecs_default_task_role_name` - ECS default task role name
* `iam_instance_profile_arn` - IAM instance profile ARN
* `security_group_id` - security group id