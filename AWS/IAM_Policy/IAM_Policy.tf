# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_policy" "ec2_full_access" {
  name        = "ec2-full-access-policy"
  description = "Policy for EC2 full access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "ec2:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_policy" "s3_full_access" {
  name        = "s3-full-access-policy"
  description = "Policy for S3 full access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "ec2_full_access_attachment" {
  name       = "ec2-full-access-attachment"
  policy_arn = aws_iam_policy.ec2_full_access.arn
  users      = [aws_iam_user.test_user.name]
}

resource "aws_iam_policy_attachment" "s3_full_access_attachment" {
  name       = "s3-full-access-attachment"
  policy_arn = aws_iam_policy.s3_full_access.arn
  users      = [aws_iam_user.test_user.name]
}
