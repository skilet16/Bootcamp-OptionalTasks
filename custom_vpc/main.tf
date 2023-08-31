# Terraform configuration 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Choosing the provider and region
provider "aws" {
         region = "eu-central-1"
}

# Creating custom vpc
resource "aws_vpc" "daniils_custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Daniils Custom VPC"
  }
}

# Creating security group within VPC
resource "aws_security_group" "daniils-final-sg" {
  name        = "daniils-custom_vpc-sg"
  description = "Security group for the custom VPC (Daniils)"
  vpc_id = aws_vpc.daniils_custom_vpc.id

  # Inbound rule [SSH] 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Inbound rule [HTTP] 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Inbound rule for [HTTPS]
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #############################
  # Outbound rule [SSH]
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule [HTTP]
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule [HTTPS]
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule [All TCP] 
  egress {
     from_port = 0
     to_port = 65535
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

}

# Creating public subnet 1
resource "aws_subnet" "daniils_subnet_public_1" {
  vpc_id     = aws_vpc.daniils_custom_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true  # Enable public IP assignment

  tags = {
    Name = "Daniils Public Subnet 1"
  }
}

# Creating public subnet 2
resource "aws_subnet" "daniils_subnet_public_2" {
  vpc_id     = aws_vpc.daniils_custom_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
  map_public_ip_on_launch = true  # Enable public IP assignment

  tags = {
    Name = "Daniils Public Subnet 2"
  }
}

# Creating private subnet 1
resource "aws_subnet" "daniils_subnet_private_1" {
  vpc_id     = aws_vpc.daniils_custom_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Daniils Private Subnet 1"
  }
}

# Creating private subnet 2
resource "aws_subnet" "daniils_subnet_private_2" {
  vpc_id     = aws_vpc.daniils_custom_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "Daniils Private Subnet 2"
  }
}

#### Providing internet access to the VPC

# Creating Internet Gateway
resource "aws_internet_gateway" "daniils_gateway" {
 vpc_id = aws_vpc.daniils_custom_vpc.id
 
 tags = {
   Name = "Daniils Custom VPC Internet Gateway"
 }
}

# Creating second route table for internet access
resource "aws_route_table" "daniils_second_route_table" {
 vpc_id = aws_vpc.daniils_custom_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.daniils_gateway.id
 }
 
 tags = {
   Name = "Daniils Second Route Table"
 }
}

# List of public subnet CIDR blocks
variable "public_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Associating public subnets with the second route table
# using the element function to dynamically select the correct subnet ID based on the count.index
resource "aws_route_table_association" "daniils_public_subnet_association" {
  count = length(var.public_subnet_cidr_blocks)
  subnet_id      = element([aws_subnet.daniils_subnet_public_1.id, aws_subnet.daniils_subnet_public_2.id], count.index)
  route_table_id = aws_route_table.daniils_second_route_table.id
}