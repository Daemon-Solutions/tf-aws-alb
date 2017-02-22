resource "aws_alb" "alb" {
  name                       = "${var.name}-alb"
  internal                   = "${var.internal}"
  security_groups            = ["${var.security_groups}"]
  subnets                    = "${var.subnets}"
  idle_timeout               = "${var.idle_timeout}"
  enable_deletion_protection = "${var.enable_deletion_protection}"

  tags {
    Name        = "${var.name}"
    Environment = "${var.envname}"
    Service     = "${var.service}"
  }
}

module "http_target_group" {
  is_enabled        = "${var.enable_http_listener == 1 || var.enable_https_listener == 1 ? 1 : 0 }"
  source            = "./target_group"
  envname           = "${var.envname}"
  envtype           = "${var.envtype}"
  service           = "${var.service}"
  target_name       = "${var.envname}-${var.service}-http-tg"
  vpc_id            = "${var.vpc_id}"
  target_port       = "${var.target_port}"
  health_check_port = "${var.target_health_check_port}"
  health_check_path = "${var.target_health_check_port}"
}

module "http_listener" {
  is_enabled        = "${var.enable_http_listener}"
  source            = "./listener"
  load_balancer_arn = "${aws_alb.alb.arn}"
  target_group_arn  = "${module.http_target_group.alb_target_group_arn}"
}

module "https_listener" {
  is_enabled               = "${var.enable_https_listener}"
  source                   = "./listener"
  listener_port            = "443"
  listener_protocol        = "HTTPS"
  listener_certificate_arn = "${var.certificate_arn}"
  load_balancer_arn        = "${aws_alb.alb.arn}"
  target_group_arn         = "${module.http_target_group.alb_target_group_arn}"
}
