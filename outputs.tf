# Outputs
#   id - The ARN of the load balancer (matches arn).
#   arn - The ARN of the load balancer (matches id).
#   arn_suffix - The ARN suffix for use with CloudWatch Metrics.
#   dns_name - The DNS name of the load balancer.
#   canonical_hosted_zone_id - The canonical hosted zone ID of the load balancer.
#   zone_id - The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record).

output "alb_id" {
  value = "${aws_alb.alb.id}"
}

output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.alb.arn_suffix}"
}

output "alb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.alb.zone_id}"
}

output "default_target_group_arn" {
  value = "${module.http_target_group.alb_target_group_arn}"
}

output "default_http_listener_arn" {
  value = "${module.http_listener.alb_listener_arn}"
}

output "default_https_listener_arn" {
  value = "${module.https_listener.alb_listener_arn}"
}
