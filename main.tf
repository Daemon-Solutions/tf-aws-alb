resource "aws_alb" "alb" {
  internal        = "${var.internal}"
  security_groups = ["${var.security_groups}"]
  subnets         = ["${var.subnets}"]

  idle_timeout = "${idle_timeout}"

  enable_deletion_protection = "${enable_deletion_protection}"

  access_logs {
    enabled = "${var.access_logs ? true : false}"
    bucket  = "${var.access_logs_bucket}"
    prefix  = "${var.access_logs_bucket_prefix}"
  }
  name                       = "${var.name_prefix != "" ? var.name_prefix : "${var.name}-alb"}"

  tags {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tags {
    key                 = "Environment"
    value               = "${var.envname}"
    propagate_at_launch = true
  }

  tags {
    key                 = "Service"
    value               = "${var.service}"
    propagate_at_launch = true
  }
}
