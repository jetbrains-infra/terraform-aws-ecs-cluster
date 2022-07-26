## About

Terraform module to run [ECS](https://aws.amazon.com/ecs/) cluster, with ASG + Launch Template + Scaling policies via capacity provider.
See details in the corresponding AWS blog post [Amazon ECS Cluster Auto Scaling is Now Generally Available](https://aws.amazon.com/ru/blogs/aws/aws-ecs-cluster-auto-scaling-is-now-generally-available/).

### Features
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
