resource "aws_autoscaling_group" "ecs_nodes" {
  name_prefix           = "CLUSTER_NODES_"
  max_size              = local.asg_max_size
  min_size              = local.asg_min_size
  vpc_zone_identifier   = local.subnets_ids
  protect_from_scale_in = local.protect_from_scale_in

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = local.on_demand_base_capacity
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

  dynamic "initial_lifecycle_hook" {
    for_each = local.lifecycle_hooks
    iterator = hook
    content {
      name                    = hook.value.name
      lifecycle_transition    = hook.value.lifecycle_transition
      default_result          = hook.value.default_result
      heartbeat_timeout       = hook.value.heartbeat_timeout
      role_arn                = hook.value.role_arn
      notification_target_arn = hook.value.notification_target_arn
      notification_metadata   = hook.value.notification_metadata
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = true
    value               = ""
  }
}
