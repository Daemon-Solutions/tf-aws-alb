/**
  * # tf-aws-alb
  *
  * AWS Application Load-Balancer (ALB) with s3 logging enabled - Terraform Module
  *
  * ## Usage
  *
  * ### Basic Usage
  *
  * ```js
  * provider "aws" {
  *  region     = "eu-west-2"
  * }
  *
  * module "alb" {
  *    source = "../modules/tf-aws-alb"
  *    envname = "dev"
  *    service = "test"
  *    name = "test"
  *    subnets = ["subnet-51353829", "subnet-e65d70ac"]
  *    security_groups = ["sg-2d4ba744"]
  *    enable_http_listener = true
  *    enable_https_listener = true
  *    vpc_id = "${var.vpc_id}"
  *    certificate_arn = "arn:aws:acm:eu-west-2:1234567890:certificate/0d549bc3-17c2-4124-82e4-8dcd2d58fe8a"
  *    access_logs_bucket = "my-alb-logs-bucket"
  *    access_logs_prefix = "alb_logs"
  *    http_stickiness = true
  *    target_health_check_path = "/healthcheck.php"
  *    target_health_check_port = "80"
  *    target_health_check_matcher = "200,302"
  * }
  * ```
  *
  * ### Advanced Usage
  *
  * If you need to use custom ports, you can call the listener and target_group submodules within this module directly.
  *
  * ## Breaking changes
  *
  * As of version 3.0.0 of this module the default is to only support TLS 1.1 and
  * above.
  * (ELBSecurityPolicy-TLS-1-1-2017-01).  When upgrading if you need to continue
  * to use the previous policy specify
  * `listener_ssl_policy` `ELBSecurityPolicy-TLS-1-0-2015-04`
  * Note that TLS 1.0 must be disabled after June 2018 to pass PCI compliance.
  *
  * As of version 2.0.0 of this module, the `alb_canonical_hosted_zone_id` output
  * has been removed.  The `alb_zone_id` output can be used instead.
  *
  * ## Modifying variables
  *
  * If you have modified variables or this README you should generate by running `terraform-docs md . > README.md`
  *
  */

resource "aws_alb" "alb" {
  name                       = "${var.name}-alb"
  internal                   = "${var.internal}"
  security_groups            = ["${var.security_groups}"]
  subnets                    = ["${var.subnets}"]
  idle_timeout               = "${var.idle_timeout}"
  enable_deletion_protection = "${var.enable_deletion_protection}"

  access_logs {
    enabled = "${var.access_logs_enabled}"
    bucket  = "${var.access_logs_bucket}"
    prefix  = "${var.access_logs_prefix}"
  }

  tags {
    Name        = "${var.name}"
    Environment = "${var.envname}"
    Service     = "${var.service}"
  }
}

module "http_target_group" {
  is_enabled                       = "${var.enable_http_listener == 1 || var.enable_https_listener == 1 ? 1 : 0 }"
  source                           = "./target_group"
  envname                          = "${var.envname}"
  service                          = "${var.service}"
  target_name                      = "${var.tgtgroup_name == "default" ?  var.envname-var.service-http-tg : var.tgtgroup_name}"
  vpc_id                           = "${var.vpc_id}"
  target_port                      = "${var.target_port}"
  health_check_port                = "${var.target_health_check_port}"
  health_check_path                = "${var.target_health_check_path}"
  health_check_matcher             = "${var.target_health_check_matcher}"
  health_check_interval            = "${var.health_check_interval}"
  health_check_timeout             = "${var.health_check_timeout}"
  health_check_healthy_threshold   = "${var.health_check_healthy_threshold}"
  health_check_unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
  stickiness                       = "${var.http_stickiness}"
  stickiness_type                  = "${var.http_stickiness_type}"
  stickiness_cookie_duration       = "${var.http_stickiness_cookie_duration}"
  deregistration_delay             = "${var.deregistration_delay}"
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
  listener_ssl_policy      = "${var.listener_ssl_policy}"
  load_balancer_arn        = "${aws_alb.alb.arn}"
  target_group_arn         = "${module.http_target_group.alb_target_group_arn}"
}
