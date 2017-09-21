tf-aws-alb
==========

AWS Application Load-Balancer (ALB) with s3 logging enabled - Terraform Module

Usage
-----

```js
provider "aws" {
 region     = "eu-west-2"
}

module "alb" {
   source = "../modules/tf-aws-alb"
   envname = "dev"
   envtype = "nonprod"
   service = "test"
   name = "test"
   subnets = ["subnet-51353829", "subnet-e65d70ac"]
   security_groups = ["sg-2d4ba744"]
   enable_http_listener = true
   enable_https_listener = true
   vpc_id = "${var.vpc_id}"
   certificate_arn = "arn:aws:acm:eu-west-2:1234567890:certificate/0d549bc3-17c2-4124-82e4-8dcd2d58fe8a"
   access_logs_bucket = "my-alb-logs-bucket"
   access_logs_prefix = "alb_logs"
   http_stickiness = true

}

module "target_group" {
   source = "../modules/tf-aws-alb/target_group"
   envname = "dev"
   envtype = "nonprod"
   service = "test"
   target_name  = "tg-8080"
   target_port = "8080"
   vpc_id = "${var.vpc_id}"
   stickiness  = true
   health_check_path = "/status"
}


module "listener" {
   source = "../modules/tf-aws-alb/listener"
   load_balancer_arn = "${module.alb.alb_arn}"
   listener_port = "8080"
   target_group_arn = "${module.target_group.alb_target_group_arn}"
}

output "default_target_group_arn" {
  value = "${module.alb.default_target_group_arn}"
}
```

Variables
---------

- `name` - The name of the ALB. This name must be unique within your AWS account.
- `enable_http_listener` - If true, enable default HTTP target group and listener.
- `enable_https_listener` - same as above but using HTTPS.
- `internal` - If set to true, the ALB will be internal.
- `security_groups` - A list of security group IDs to assign to the LB.
- `subnets` - A list of subnet IDs to attach to the LB.
- `idle_timeout` - The time in seconds that the connection is allowed to be idle.
- `enable_deletion_protection` - If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false.
- `access_logs_bucket` - The S3 bucket name to store the logs in.
- `access_logs_prefix` - The S3 bucket prefix. Logs are stored in the root if not configured
- `http_stickiness` - If true, enable stickiness for the default HTTP/s listener's target group (default `false`)
- `deregistration_delay` - Sets the delay the Load Balancer uses before moving a machine from deregistered to unused.


_Below variables are used to configure default target group and listeners:_

- `certificate_arn` - ARN of the certificate to use for HTTPS listner. Required if `enable_https_listener` is `true`.
- `vpc_id` - Required if `enable_http_listener` or `enable_https_listener` is `true`.  The identifier of the VPC in which to create the target group.

Outputs
-------

- `alb_id` - The ARN of the load balancer (matches arn).
- `alb_arn` - The ARN of the load balancer (matches id).
- `alb_arn_suffix` - The ARN suffix for use with CloudWatch Metrics.
- `alb_dns_name` - The DNS name of the load balancer.
- `alb_canonical_hosted_zone_id` - The canonical hosted zone ID of the load balancer.
- `alb_zone_id` - The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record).
- `default_target_group_arn` - Default target group's ARN (ID).
