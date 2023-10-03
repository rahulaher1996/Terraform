# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "test_group" {
  name = "test group"
}

resource "aws_iam_user" "test_user" {
  name = "test-user"
}

resource "aws_iam_group_membership" "test_user_group_membership" {
  name       = "test group"
  users      = [aws_iam_user.test_user.name]
  group      = aws_iam_group.test_group.name
}
