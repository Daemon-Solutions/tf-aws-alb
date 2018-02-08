/**
  * tf-aws-alb
  * ==========
  *
  * AWS Application Load-Balancer (ALB) with s3 logging enabled - Terraform Module
  *
  * Usage
  * -----
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
  *
  * module "target_group" {
  *    source = "../modules/tf-aws-alb/target_group"
  *    envname = "dev"
  *    service = "test"
  *    target_name  = "tg-8080"
  *    target_port = "8080"
  *    vpc_id = "${var.vpc_id}"
  *    stickiness  = true
  *    health_check_path = "/status"
  * }
  *
  *
  * module "listener" {
  *    source = "../modules/tf-aws-alb/listener"
  *    load_balancer_arn = "${module.alb.alb_arn}"
  *    listener_port = "8080"
  *    target_group_arn = "${module.target_group.alb_target_group_arn}"
  * }
  *
  * output "default_target_group_arn" {
  *   value = "${module.alb.default_target_group_arn}"
  * }
  * ```
  *
  *
  * resource "aws_alb" "alb" {
  *   name                       = "${var.name}-alb"
  *   internal                   = "${var.internal}"
  *   security_groups            = ["${var.security_groups}"]
  *   subnets                    = ["${var.subnets}"]
  *   idle_timeout               = "${var.idle_timeout}"
  *   enable_deletion_protection = "${var.enable_deletion_protection}"
  *
  *   access_logs {
  *     enabled = "${var.access_logs_enabled}"
  *     bucket  = "${var.access_logs_bucket}"
  *     prefix  = "${var.access_logs_prefix}"
  *   }
  *
  *   tags {
  *     Name        = "${var.name}"
  *     Environment = "${var.envname}"
  *     Service     = "${var.service}"
  *   }
  * }
  *
  * Breaking changes
  * ----------------
  * As of version 2.0.0 of this module, the `alb_canonical_hosted_zone_id` output has been removed.  The `alb_zone_id` output can be used instead.
  *
  * Modifying variables
  * -------------------
  *
  * If you have modified variables or this README you should generate by running `terraform-docs md . > README.md`
  *
  */

module "http_target_group" {
  is_enabled                       = "${var.enable_http_listener              =  = 1 || var.enable_https_listener =  = 1 ? 1 : 0 }"
  source                           = "./target_group"
  envname                          = "${var.envname}"
  service                          = "${var.service}"
  target_name                      = "${var.envname}-${var.service}-http-tg"
  vpc_id                           = "${var.vpc_id}"
  target_port                      = "${var.target_port}"
  health_check_port                = "${var.target_health_check_port}"
  health_check_path                = "${var.target_health_check_path}"
  health_check_matcher             = "${var.target_health_check_matcher}"
  health_check_interval            = "${var.health_check_interval}"
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
  load_balancer_arn        = "${aws_alb.alb.arn}"
  target_group_arn         = "${module.http_target_group.alb_target_group_arn}"
}
