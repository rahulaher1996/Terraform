# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Create a Security Group 
resource "aws_security_group" "test" {
  name = "terraform-example"
  
  ingress {
    from_port	  = 8080
    to_port	    = 8080
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }
}
