## About

Terraform module to run ECS cluster, with ASG + Launch Template + Scaling policies via capacity provider.
See details in the corresponding AWS blog post [Amazon ECS Cluster Auto Scaling is Now Generally Available](https://aws.amazon.com/ru/blogs/aws/aws-ecs-cluster-auto-scaling-is-now-generally-available/).

Features:

* ECS cluster manages ASG capacity automatically.
* ASG with optional spot instances support.
* It's possible to specify various instance types for your cluster.
* EC2 instance profile with SSM policy - you can connect to the instances using the Session Manager.
* Default ECS task role allows creating a log group.
* Default security group for ECS nodes allow inbound connections from configurable list of network CIDRs.
* It's possible to specify additional security groups for ECS nodes.
* Latest ECS Optimized AMI with `amd64` or `arm64` architectures.
* Additional EBS disks.
* ASG lifecycle hooks.

## Usage

```hcl
module "example_ecs_cluster" {
  source              = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name        = "FooBar"
  spot                = true
  arm64               = true

  instance_types = {
    "t3a.large"  = 1
    "t3a.xlarge" = 2
  }

  target_capacity = 100

  // subnets with ALB and bastion host e.g..
  trusted_cidr_blocks = [
    aws_subnet.public_subnet_1.cidr_block,
    aws_subnet.public_subnet_2.cidr_block
  ]

  ebs_disks = {
    "/dev/sda" = 100
  }

  subnets_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  lifecycle_hooks = [

    {
      name                    = "Example"
      lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
      default_result          = "CONTINUE"
      heartbeat_timeout       = 2000
      role_arn                = aws_iam_role.example.arn
      notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1"
      notification_metadata   = <<EOF
{
  "foo": "bar"
}
EOF
    }
  ]
}
```

Default values:

```hcl
module "example_ecs_cluster" {
  source              = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name        = "FooBar"
  spot                = false
  arm64               = false

  instance_types = {
    "t3a.small"  = 2
  }

  target_capacity     = 100
  security_group_ids  = []
  // subnets with ALB and bastion host e.g..
  trusted_cidr_blocks = []
  lifecycle_hooks     = []

  subnets_ids         = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
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
* `capacity_provider_name` - capacity provider name (the same name for ASG)
