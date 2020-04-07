resource "aws_autoscaling_group" "ecs_nodes" {
  name_prefix           = "CLUSTER_NODES_"
  max_size              = 100
  min_size              = 0
  vpc_zone_identifier   = local.subnets_ids
  protect_from_scale_in = true

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = local.spot
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.node.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = local.instance_types
        content {
          instance_type     = override.key
          weighted_capacity = override.value
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    key                 = "AmazonECSManaged",
    propagate_at_launch = true
  }, local.tags)
}

