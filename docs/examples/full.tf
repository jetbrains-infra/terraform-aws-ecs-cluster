module "example_ecs_cluster" {
  source               = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name         = "FooBar"
  spot                 = true
  arm64                = true
  target_capacity      = 100
  nodes_with_public_ip = true

  instance_types = {
    "t3a.large"  = 1
    "t3a.xlarge" = 2
  }

  // subnets with ALB and bastion host e.g..
  trusted_cidr_blocks = [
    aws_subnet.public_subnet_1.cidr_block,
    aws_subnet.public_subnet_2.cidr_block
  ]

  ebs_disks = {
    "/dev/sda" = 100
  }

  // subnets where the ECS nodes are hosted
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
