resource "aws_security_group" "ecs_nodes" {
  description = "ECS node"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${split(",", var.trusted_security_groups)}"]
  }
  # allow internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}