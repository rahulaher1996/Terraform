# Create a new VPC if it doesn't exist, or use an existing one
resource "aws_vpc" "test-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

# Create a new security group
resource "aws_security_group" "test-sg" {
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

  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-sg"
  }
}

# Create a new subnet in the VPC
resource "aws_subnet" "test-subnet" {
  vpc_id                  = aws_vpc.test-vpc.id
  cidr_block              = aws_vpc.test-vpc.cidr_block # Same as VPC CIDR
  availability_zone       = "us-east-1a" # Change to your desired availability zone
  map_public_ip_on_launch = true # Set this as needed

  tags = {
    Name = "test-subnet"
  }
}

# Create an EBS volume
resource "aws_ebs_volume" "test-ebs" {
  availability_zone = "us-east-1a" # Change to your desired availability zone
  size             = 8 # Size of the EBS volume in gigabytes

  tags = {
    Name = "test-ebs"
  }
}

# Create an EC2 instance
resource "aws_instance" "test-ec2" {
  ami           = "ami-03a6eaae9938c858c" # Replace with your desired AMI ID
  instance_type = "t2.micro" # Change to your desired instance type

  vpc_security_group_ids = [aws_security_group.test-sg.id]
  subnet_id              = aws_subnet.test-subnet.id # Use the new subnet

  root_block_device {
    volume_type = "gp2"
    volume_size = aws_ebs_volume.test-ebs.size
  }

  tags = {
    Name = "test-ec2"
  }
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.test-ec2.id
}
