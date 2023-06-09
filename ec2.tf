# Create a security group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

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

  tags = {
    Name = "MySecurityGroup"
  }
}

# Create three EC2 instances and associate them with the security group
resource "aws_instance" "my_instance" {
  count         = 3
  ami           = var.ami 
  instance_type = var.instance_type     
  subnet_id                     = aws_subnet.private_subnet[count.index].id
  vpc_security_group_ids        = [aws_security_group.my_security_group.id]
  associate_public_ip_address   = true

  user_data = file("installapache.sh")

  tags = {
    Name = "MyInstance-${count.index}"
  }
}

# Attach 2 GB EBS volumes to each instance
resource "aws_volume_attachment" "my_volume_attachment" {
  count       = 3
  device_name = "/dev/sdf" # Change to the appropriate device name for Windows instances

  volume_id   = aws_ebs_volume.my_volume[count.index].id
  instance_id = aws_instance.my_instance[count.index].id
}

# Create 2 GB EBS volumes for each instance
resource "aws_ebs_volume" "my_volume" {
  count             = 3
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  size              = 2
  encrypted         = true

  tags = {
    Name = "MyVolume-${count.index}"
  }
}



# Output the instance IDs
output "instance_ids" {
  value = aws_instance.my_instance[*].id
}
