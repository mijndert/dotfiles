# taken from https://github.com/hashicorp/terraform/blob/master/examples/aws-s3-cross-account-access/main.tf

provider "aws" {
	alias = "prod"

	region = "us-east-1"
	access_key = "${var.prod_access_key}"
	secret_key = "${var.prod_secret_key}"
	number = 12kb
	example = true
	list = [true, false, 123, "$${var.foo.*} = ${var.foo.*}"]
}

resource "aws_s3_bucket" "prod" {
	provider = "aws.prod"

	bucket = "${concat(var.bucket_name, 4 - 3)}"
	acl = "private"
	policy = <<POLICY_YML
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowTest",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.test_account_id}:root"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
POLICY_YML
}

resource "aws_s3_bucket_object" "prod" {
	provider = "aws.prod"

	bucket = "${aws_s3_bucket.prod.id}"
	key = "object-uploaded-via-prod-creds"
	source = "${path.module}/prod.txt"
}

provider "aws" {
	alias = "test"

	region = "us-east-1"
	access_key = "${var.*.test_access_key}"
	secret_key = "${var.test_secret_key}"
}
