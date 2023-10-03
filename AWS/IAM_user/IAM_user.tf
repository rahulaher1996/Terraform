# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_user" "test_user" {
  name = "test-user"
}

resource "aws_iam_access_key" "test_user_access_key" {
  user = aws_iam_user.test_user.name
}

resource "aws_iam_user_login_profile" "test_user_login_profile" {
  user                    = aws_iam_user.test_user.name
  password_reset_required = false
  pgp_key                 = ""
  password_length         = 10
  password               = "Password@12345"
}
