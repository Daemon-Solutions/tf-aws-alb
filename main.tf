resource "aws_alb" "alb" {
  internal        = "${var.internal}"
  security_groups = ["${var.security_groups}"]
  subnets         = ["${var.subnets}"]

  idle_timeout = "${idle_timeout}"

  enable_deletion_protection = "${enable_deletion_protection}"

  name                       = "${var.name_prefix != "" ? var.name_prefix : "${var.name}-alb"}"

  tags {
    Name        = "${var.name}"
    Environment = "${var.envname}"
    Service     = "${var.service}"
  }
}


}
