data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<EOT
#!/bin/bash
echo ECS_CLUSTER="${local.name}" >> /etc/ecs/ecs.config
echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
echo ECS_ENABLE_SPOT_INSTANCE_DRAINING=${tostring(var.spot)} >> /etc/ecs/ecs.config

EOT
  }

  dynamic "part" {
    for_each = local.user_data
    content {
      content_type = "text/x-shellscript"
      content      = part.value
    }
  }
}

resource "aws_launch_template" "node" {
  name_prefix            = "ecs_node_"
  image_id               = local.ami_id
  instance_type          = "t3a.small"
  vpc_security_group_ids = local.sg_ids
  user_data              = data.template_cloudinit_config.config.rendered
  tags                   = local.tags
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_node.name
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
}