resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.

  filename      = data.archive_file.my_lambda_function.output_path
  function_name = "${var.lambda_name}_${terraform.workspace}"
  role          = aws_iam_role.lambda_sqs_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 6

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.my_lambda_function.output_base64sha256
  runtime          = "python3.8"
  tags = {
    Environment = "${terraform.workspace}"
  }

}

data "archive_file" "my_lambda_function" {
  type        = "zip"
  output_path = "my_lambda_function.zip"
  source_file = "lambda_function.py"

}

resource "aws_iam_role" "lambda_sqs_role" {
  name = "iam_role_for_lambda88_${terraform.workspace}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }

}

resource "aws_sqs_queue" "main_queue" {
  name                      = "my-main-queue_${terraform.workspace}"
  delay_seconds             = 30
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "${terraform.workspace}"
  }

  depends_on = [
    aws_sqs_queue.dlq_queue
  ]

}
#The purpose dead letter queue is to pull any unprocessed messages 
resource "aws_sqs_queue" "dlq_queue" {
  name             = "my-dlq-queue_${terraform.workspace}"
  delay_seconds    = 30
  max_message_size = 262144

}

resource "aws_lambda_event_source_mapping" "sqs-lambda-trigger" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.test_lambda.arn
  enabled          = true
  depends_on = [
    aws_sqs_queue.main_queue
  ]
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.lambda_sqs_role.name
  count      = length(var.iam_policy_arn)
  policy_arn = var.iam_policy_arn[count.index]
  depends_on = [
    aws_iam_role.lambda_sqs_role
  ]
}
