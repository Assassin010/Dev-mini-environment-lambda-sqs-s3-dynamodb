resource "aws_s3_bucket" "forbackend" {
  bucket        = var.s3_bucket_name
  acl           = "private"
  force_destroy = "true"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name        = "mybucket"
    Environment = "${terraform.workspace}"
  }

}


resource "aws_dynamodb_table" "dynamodb-terraform-lock" {
  name           = "terraform-lock-Dev"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "${terraform.workspace}"
  }

  depends_on = [
    aws_s3_bucket.forbackend
  ]
}
