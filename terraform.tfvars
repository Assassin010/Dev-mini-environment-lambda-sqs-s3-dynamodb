aws_region = {
  default = "us-east-1"
  dev     = "us-east-2"
  prod    = "eu-central-1"
}

lambda_name = "lambda_function"

s3_bucket_name = "forbackend"



iam_policy_arn = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/AmazonSQSFullAccess", "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
