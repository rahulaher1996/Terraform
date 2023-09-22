# Define the AWS provider configuration
provider "aws" {
  region = "us-east-1"
}

# Define an AWS key pair for SSH access (you can create the key pair in advance)
resource "aws_key_pair" "example_keypair" {
  key_name   = "example-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # Change to your public key path
}

# Define a VPC (Virtual Private Cloud) if you don't have one
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define a security group to allow SSH and any additional rules you need
resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all for SSH access (restrict in production)
  }

  # Add additional ingress rules as needed

  vpc_id = aws_vpc.example_vpc.id
}

# Define an Elastic IP address for the instance
resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
}

# Define an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Change to your desired AMI ID
  instance_type = "t2.micro"             # Change to your desired instance type

  key_name = aws_key_pair.example_keypair.key_name
  vpc_security_group_ids = [aws_security_group.example_sg.id]

  # Specify the VPC subnet if required
  subnet_id = aws_subnet.example_subnet.id

  # Define additional volumes (EBS)
  root_block_device {
    volume_size = 30 # Size in GB
  }

  # Attach additional volumes if needed
  # ...

  tags = {
    Name = "example-instance"
  }
}

# Optionally, define a subnet within the VPC (if you don't already have one)
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.0.0/24" # Customize your subnet CIDR block
  availability_zone       = "us-east-1a" # Customize the availability zone
  map_public_ip_on_launch = true # This allows instances in the subnet to get public IPs
}
