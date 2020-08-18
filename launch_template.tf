resource "aws_launch_template" "node" {
  name_prefix            = "ecs_node_"
  image_id               = local.ami_id
  instance_type          = "t3a.small"
  vpc_security_group_ids = local.sg_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_node.name
  }

  user_data = base64encode(<<EOT
#!/bin/bash
echo ECS_CLUSTER="${local.name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=${tostring(var.spot)} >> /etc/ecs/ecs.config

EOT
)

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }

  tags = local.tags
}