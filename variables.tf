

variable "aws_region" {
}



variable "s3_bucket_name" {
}

variable "lambda_name" {}



variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type        = list(string)
}