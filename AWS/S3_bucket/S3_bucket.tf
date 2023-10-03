# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "testtmyybuckett" {
  bucket = "testtmyybuckett"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.testtmyybuckett.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
