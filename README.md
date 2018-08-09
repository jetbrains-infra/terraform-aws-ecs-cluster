## About
Terraform module to run ECS cluster on AutoScalingGroup of EC2 instances. 


## Usage

Default cluster with 3 `m5.large` instances:
```
module "example_ecs_cluster" {
  source                = "github.com/jetbrains-infra/terraform-aws-ecs-cluster"
  cluster_name          = "Example"
  cluster_subnets       = ["${aws_subnet.private_subnet_1.id}","${aws_subnet.private_subnet_2.id}"]
  trusted_cidr_blocks   = ["${aws_subnet.public_subnet_1.cidr_block}","${aws_subnet.public_subnet_2.cidr_block}"]
  ssh_key_name          = "example"
}
```

All options with default values:
```
module "example_ecs_cluster" {
  source                = "github.com/jetbrains-infra/terraform-aws-ecs-cluster"
  cluster_name          = "Example"
  cluster_subnets       = ["${aws_subnet.private_subnet_1.id}","${aws_subnet.private_subnet_2.id}"]
  trusted_cidr_blocks   = ["${aws_subnet.public_subnet_1.cidr_block}","${aws_subnet.public_subnet_2.cidr_block}"]
  root_partition_size   = 20
  docker_partition_size = 50
  instance_type         = "m5.large"
  ssh_key_name          = "example"
  desired_capacity      = 3
}
```

## Outputs

* `name` - cluster name
* `ecs_service_role_name` - ECS service role name
* `cluster_id` - cluster id
* `security_group` - security group id
* `iam_instance_profile_arn` - IAM instance profile ARN