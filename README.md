# tf-aws-alb

AWS Application Load-Balancer (ALB) with s3 logging enabled - Terraform Module

## Usage

### Basic Usage

```js
provider "aws" {
 region     = "eu-west-2"
}

module "alb" {
   source = "../modules/tf-aws-alb"
   envname = "dev"
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
   target_health_check_path = "/healthcheck.php"
   target_health_check_port = "80"
   target_health_check_matcher = "200,302"
}
```

### Advanced Usage

If you need to use custom ports, you can call the listener and target_group submodules within this module directly.

## Breaking changes

As of version 5.0.0 of this module the module only supports Terraform 0.12.x and upwards.

As of version 4.0.0 of this module the module no longer appends '-alb' to the
name of the ALB.

As of version 3.0.0 of this module the default is to only support TLS 1.1 and
above.
(ELBSecurityPolicy-TLS-1-1-2017-01).  When upgrading if you need to continue
to use the previous policy specify
`listener_ssl_policy` `ELBSecurityPolicy-TLS-1-0-2015-04`
Note that TLS 1.0 must be disabled after June 2018 to pass PCI compliance.

As of version 2.0.0 of this module, the `alb_canonical_hosted_zone_id` output
has been removed.  The `alb_zone_id` output can be used instead.

## Inputs

| Name | Description | Default | Required |
|------|-------------|:-----:|:-----:|
| access_logs_bucket | The S3 bucket name to store the logs in. Valid only if access_logs is set to true | - | yes |
| access_logs_enabled | Enable or disable logs | `true` | no |
| access_logs_prefix | The S3 bucket prefix. Logs are stored in the root if not configured | `alb_logs` | no |
| certificate_arn | arn of the certificate to use for HTTPS listner | `` | no |
| deregistration_delay | (Optional) The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. | `300` | no |
| enable_deletion_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. | `false` | no |
| enable | If false, the ALB services will not be provisioned | `true` | no |
| enable_http_listener | If true, enable default HTTP target group and listener | `false` | no |
| enable_https_listener | If true, enable default HTTPS target group and listener | `false` | no |
| envname |  | - | yes |
| health_check_healthy_threshold | (Optional) The number of consecutive health checks successes required before considering an unhealthy target healthy. | `2` | no |
| health_check_interval | (Optional) The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. | `5` | no |
| health_check_timeout | (Optional) The amount of time, in seconds, during which no response means a failed health check. | `3` | no |
| health_check_unhealthy_threshold | (Optional) The number of consecutive health check failures required before considering the target unhealthy. | `2` | no |
| http_stickiness | (Optional) If true, enables stickiness | `false` | no |
| http_stickiness_cookie_duration | (Optional) The time period, in seconds, during which requests from a client should be routed to the same target. After this time period expires, the load balancer-generated cookie is considered stale. The range is 1 second to 1 week (604800 seconds). | `86400` | no |
| http_stickiness_type | (Required) The type of sticky sessions. The only current possible value is lb_cookie. | `lb_cookie` | no |
| idle_timeout | The time in seconds that the connection is allowed to be idle. | `60` | no |
| internal | If true, the ALB will be internal | `false` | no |
| listener_ssl_policy | The name of the SSL Policy for the listener. See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html for a list of policies. | `ELBSecurityPolicy-TLS-1-1-2017-01` | no |
| name | The name of the ALB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb. | - | yes |
| security_groups | A list of security group IDs to assign to the LB | `<list>` | no |
| service |  | - | yes |
| subnets | A list of subnet IDs to attach to the LB | `<list>` | no |
| target_health_check_matcher | (Optional) The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299"). | `200` | no |
| target_health_check_path | The destination for the health check request. | `/` | no |
| target_health_check_port | The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. | `80` | no |
| target_port | The port on which targets receive traffic, unless overridden when registering a specific target | `80` | no |
| vpc_id | (Required) The identifier of the VPC in which to create the target group. | `` | no |
| target_group_name | (Optional) The name of the Target Group to override default value | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_name | The name of the load balancer. |
| alb_arn | The ARN of the load balancer (matches id). |
| alb_arn_suffix | The ARN suffix for use with CloudWatch Metrics. |
| alb_dns_name | The DNS name of the load balancer. |
| alb_id | The ARN of the load balancer (matches arn). |
| alb_zone_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| default_http_listener_arn | ARN for the default HTTP listener |
| default_https_listener_arn | ARN for the default HTTPS listener |
| default_target_group_arn | ARN for the default target group |

