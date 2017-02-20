# Outputs
#   id - The ARN of the Target Group (matches arn)
#   arn - The ARN of the Target Group (matches id)
#   arn_suffix - The ARN suffix for use with CloudWatch Metrics.

output "alb_target_group_id" {
  value = "${aws_alb_target_group.alb_target_group.id}"
}

output "alb_target_group_arn" {
  value = "${aws_alb_target_group.alb_target_group.arn}"
}

output "alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.alb_target_group.arn_suffix}"
}
