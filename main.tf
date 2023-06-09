provider "aws" {
  region = "us-east-1" 
  
  access_key = "AKIARY6HVTTO4ZJI4D3Q"
  secret_key = "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"
}




# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "Kartavya.Srivastav@intuitive.cloud"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Kartavya.Srivastav@intuitive.cloud"
  }
}

# Create public subnets
resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"

  availability_zone =  element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24" # Update with your desired CIDR block range

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Kartavya.Srivastav@intuitive.cloud"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a route table for private subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "Kartavya.Srivastav@intuitive.cloud"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

