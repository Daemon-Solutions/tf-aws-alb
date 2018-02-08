# Outputs

output "alb_id" {
  value       = "${aws_alb.alb.id}"
  description = "The ARN of the load balancer (matches arn)."
}

output "alb_arn" {
  value       = "${aws_alb.alb.arn}"
  description = "The ARN of the load balancer (matches id)."
}

output "alb_arn_suffix" {
  value       = "${aws_alb.alb.arn_suffix}"
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_dns_name" {
  value       = "${aws_alb.alb.dns_name}"
  description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
  value       = "${aws_alb.alb.zone_id}"
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "default_target_group_arn" {
  value       = "${module.http_target_group.alb_target_group_arn}"
  description = "ARN for the default target group"
}

output "default_http_listener_arn" {
  value       = "${module.http_listener.alb_listener_arn}"
  description = "ARN for the default HTTP listener"
}

output "default_https_listener_arn" {
  value       = "${module.https_listener.alb_listener_arn}"
  description = "ARN for the default HTTPS listener"
}
