# Outputs
#   id - The ARN of the Target Group (matches arn)
#   arn - The ARN of the Target Group (matches id)
#   arn_suffix - The ARN suffix for use with CloudWatch Metrics.

output "alb_target_group_id" {
  value = "${element(aws_alb_target_group.alb_target_group.*.id, 0)}"
}

output "alb_target_group_arn" {
  value = "${element(aws_alb_target_group.alb_target_group.*.arn, 0)}"
}

output "alb_target_group_arn_suffix" {
  value = "${element(aws_alb_target_group.alb_target_group.*.arn_suffix, 0)}"
}
