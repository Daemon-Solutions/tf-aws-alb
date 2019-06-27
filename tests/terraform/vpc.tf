provider "random" {
}

resource "random_pet" "log_bucket" {
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "test-${random_pet.log_bucket.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSELBS3Logging",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Principal": { "AWS": "arn:aws:iam::156460612806:root" },
      "Resource": "arn:aws:s3:::test-${random_pet.log_bucket.id}/*"
    }
  ]
}
POLICY

}

resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all HTTP/HTTPS traffic"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc" {
  source = "claranet/vpc-modules/aws"
  version = "1.0.0"

  enable_dns_support = true
  enable_dns_hostnames = true

  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  vpc_cidr_block = "10.112.0.0/16"

  public_cidr_block = "10.112.0.0/20"
  public_subnet_count = 3

  private_cidr_block = "10.112.16.0/20"
  private_subnet_count = 3
}

