resource "aws_security_group" "ecs_nodes" {
  name = "ECS nodes"
  vpc_id = "${local.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.trusted_cidr_blocks}"]
  }

  # allow internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}