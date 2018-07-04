resource "aws_launch_configuration" "default" {
  name_prefix          = "${var.cluster_name}-lc-"
  image_id             = "${data.aws_ami.ecs.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.ecs_nodes.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_node.id}"
  key_name             = "${var.ssh_key_name}"

  user_data            = <<USERDATA
#!/bin/bash
echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config

USERDATA

  root_block_device {
    volume_size = "${var.root_partition_size}"
    volume_type = "gp2"
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    // Disk naming is important!
    volume_size = "${var.docker_partition_size}"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  name                 = "${lower(var.cluster_name)}-ecs-asg"
  launch_configuration = "${aws_launch_configuration.default.id}"
  desired_capacity     = "${var.desired_capacity}"
  max_size             = "${var.desired_capacity}"
  min_size             = "${var.desired_capacity}"
  vpc_zone_identifier  = ["${var.cluster_subnets}"]

  tag {
    key                 = "Name"
    value               = "ECS Cluster ${var.cluster_name}"
    propagate_at_launch = true
  }

}
