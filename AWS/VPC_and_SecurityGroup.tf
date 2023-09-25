# Create a new VPC if it doesn't exist, or use an existing one
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Create a new security group
resource "aws_security_group" "example" {
  name        = "example"
  description = "Example Security Group"

  // Define your security group rules here
  // For example, allow SSH and HTTP traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.example.id
}
