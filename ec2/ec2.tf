provider "aws" {
    region = "eu-central-1"
}

resource "aws_instance" "ec2_with_terraform" {
    ami = "ami-062f79c1d054dd995"
    instance_type = "t2.micro"
    tags = {
        Name = "ec2_with_terraform"
    }
  
}
