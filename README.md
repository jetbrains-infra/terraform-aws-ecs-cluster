<!-- BEGIN_TF_DOCS -->
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

## Usage

Minimal
```hcl
module "example_ecs_cluster" {
  source       = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name = "FooBar"

  // subnets where the ECS nodes are hosted
  subnets_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}
```

Full example
```hcl
module "example_ecs_cluster" {
  source          = "github.com/jetbrains-infra/terraform-aws-ecs-cluster?ref=vX.X.X" // see https://github.com/jetbrains-infra/terraform-aws-ecs-cluster/releases
  cluster_name    = "FooBar"
  spot            = true
  arm64           = true
  target_capacity = 100

  instance_types = {
    "t4g.large"  = 1
    "t4g.xlarge" = 2
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
```

## Required Inputs

The following input variables are required:

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: Cluster name.

Type: `any`

### <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids)

Description: IDs of subnets. Use subnets from various availability zones to make the cluster more reliable.

Type: `list(string)`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_arm64"></a> [arm64](#input\_arm64)

Description: ECS node architecture.

Type: `bool`

Default: `false`

### <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size)

Description: The maximum size the auto scaling group (measured in EC2 instances).

Type: `number`

Default: `100`

### <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size)

Description: The minimum size the auto scaling group (measured in EC2 instances).

Type: `number`

Default: `0`

### <a name="input_ebs_disks"></a> [ebs\_disks](#input\_ebs\_disks)

Description: A list of additional EBS disks.

Type: `map(string)`

Default: `{}`

### <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types)

Description: ECS node instance types. Maps of pairs like `type = weight`. Where weight gives the instance type a proportional weight to other instance types.

Type: `map(any)`

Default:

```json
{
  "t3a.small": 2
}
```

### <a name="input_lifecycle_hooks"></a> [lifecycle\_hooks](#input\_lifecycle\_hooks)

Description: A list of maps containing the name,lifecycle\_transition,default\_result,heartbeat\_timeout,role\_arn,notification\_target\_arn keys.

Type:

```hcl
list(object({
    name                    = string
    lifecycle_transition    = string
    default_result          = string
    heartbeat_timeout       = number
    role_arn                = string
    notification_target_arn = string
    notification_metadata   = string
  }))
```

Default: `[]`

### <a name="input_on_demand_base_capacity"></a> [on\_demand\_base\_capacity](#input\_on\_demand\_base\_capacity)

Description: The minimum number of on-demand EC2 instances.

Type: `number`

Default: `0`

### <a name="input_protect_from_scale_in"></a> [protect\_from\_scale\_in](#input\_protect\_from\_scale\_in)

Description: The autoscaling group will not select instances with this setting for termination during scale in events.

Type: `bool`

Default: `true`

### <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids)

Description: Additional security group IDs. Default security group would be merged with the provided list.

Type: `list`

Default: `[]`

### <a name="input_spot"></a> [spot](#input\_spot)

Description: Choose should we use spot instances or on-demand to populate ECS cluster.

Type: `bool`

Default: `false`

### <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity)

Description: The target utilization for the cluster. A number between 1 and 100.

Type: `string`

Default: `"100"`

### <a name="input_trusted_cidr_blocks"></a> [trusted\_cidr\_blocks](#input\_trusted\_cidr\_blocks)

Description: List of trusted subnets CIDRs with hosts that should connect to the cluster. E.g., subnets with ALB and bastion hosts.

Type: `list(string)`

Default:

```json
[]
```

### <a name="input_user_data"></a> [user\_data](#input\_user\_data)

Description: A shell script will be executed at once at EC2 instance start.

Type: `string`

Default: `""`

## Outputs

The following outputs are exported:

### <a name="output_arn"></a> [arn](#output\_arn)

Description: Cluster ARN.

### <a name="output_capacity_provider_name"></a> [capacity\_provider\_name](#output\_capacity\_provider\_name)

Description: capacity provider name (the same name for ASG).

### <a name="output_ecs_default_task_role_arn"></a> [ecs\_default\_task\_role\_arn](#output\_ecs\_default\_task\_role\_arn)

Description: ECS default task role ARN.

### <a name="output_ecs_default_task_role_name"></a> [ecs\_default\_task\_role\_name](#output\_ecs\_default\_task\_role\_name)

Description: ECS default task role name.

### <a name="output_ecs_service_role_arn"></a> [ecs\_service\_role\_arn](#output\_ecs\_service\_role\_arn)

Description: ECS service role ARN.

### <a name="output_ecs_service_role_name"></a> [ecs\_service\_role\_name](#output\_ecs\_service\_role\_name)

Description: ECS service role name.

### <a name="output_iam_instance_profile_arn"></a> [iam\_instance\_profile\_arn](#output\_iam\_instance\_profile\_arn)

Description: IAM instance profile ARN.

### <a name="output_iam_instance_profile_name"></a> [iam\_instance\_profile\_name](#output\_iam\_instance\_profile\_name)

Description: IAM instance profile name.

### <a name="output_iam_instance_role_name"></a> [iam\_instance\_role\_name](#output\_iam\_instance\_role\_name)

Description: IAM instance role name.

### <a name="output_id"></a> [id](#output\_id)

Description: Cluster ID.

### <a name="output_name"></a> [name](#output\_name)

Description: Cluster name.

### <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id)

Description: The ID of the ECS nodes security group.

### <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name)

Description: The name of the ECS nodes security group.

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

- <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit)

## Resources

The following resources are used by this module:

- [aws_autoscaling_group.ecs_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) (resource)
- [aws_ecs_capacity_provider.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) (resource)
- [aws_ecs_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) (resource)
- [aws_iam_instance_profile.ecs_node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) (resource)
- [aws_iam_role.ec2_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role.ecs_service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_iam_role_policy.allow_create_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) (resource)
- [aws_iam_role_policy_attachment.default_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.ecs_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.service_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_iam_role_policy_attachment.ssm_core_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) (resource)
- [aws_launch_template.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) (resource)
- [aws_security_group.ecs_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) (resource)
- [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) (resource)
- [aws_iam_policy_document.allow_create_log_groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_iam_policy_document.ec2_instance_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_iam_policy_document.ecs_service_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_iam_policy_document.ecs_task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_ssm_parameter.ecs_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) (data source)
- [aws_ssm_parameter.ecs_ami_arm64](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) (data source)
- [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) (data source)
- [cloudinit_config.config](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) (data source)

<!-- END_TF_DOCS -->
