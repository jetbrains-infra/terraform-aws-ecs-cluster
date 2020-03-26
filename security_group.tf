resource "aws_security_group" "ecs_nodes" {
  name   = "ECS nodes for ${local.name}"
  vpc_id = local.vpc_id
  tags   = local.tags
}

resource "aws_security_group_rule" "ingress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = local.trusted_cidr_blocks
  security_group_id = aws_security_group.ecs_nodes.id
  type              = "ingress"
}

resource "aws_security_group_rule" "egress" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_nodes.id
  type              = "egress"
}