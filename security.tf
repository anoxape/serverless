### lb

resource "aws_security_group" "lb" {
  name        = "${var.name}-lb"
  description = "lb security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "lb_ingress" {
  security_group_id = aws_security_group.lb.id
  description       = "allow ingress CIDR blocks to access lb"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = aws_lb_listener.lb.port
  to_port           = aws_lb_listener.lb.port
  cidr_blocks       = var.lb_ingress_cidr_blocks
}

resource "aws_security_group_rule" "lb_egress_lambda" {
  security_group_id        = aws_security_group.lb.id
  description              = "allow lb to access lambda"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = aws_lb_listener.lb.port
  to_port                  = aws_lb_listener.lb.port
  source_security_group_id = aws_security_group.lambda.id
}

### lambda

resource "aws_security_group" "lambda" {
  name        = "${var.name}-lambda"
  description = "lambda security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "lambda_ingress_lb" {
  security_group_id        = aws_security_group.lambda.id
  description              = "allow lambda to be accessed from lb"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = aws_lb_listener.lb.port
  to_port                  = aws_lb_listener.lb.port
  source_security_group_id = aws_security_group.lb.id
}
