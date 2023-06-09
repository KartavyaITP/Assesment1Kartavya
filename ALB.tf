# Create an Application Load Balancer
resource "aws_lb" "my_alb" {
  name               = "MyALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_security_group.id]
  subnets            = aws_subnet.public_subnet[*].id

  tags = {
    Name = "MyALB"
  }
}

# Create a target group for the EC2 instances
resource "aws_lb_target_group" "my_target_group" {
  name        = "MyTargetGroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  tags = {
    Name = "MyTargetGroup"
  }
}

# Register the EC2 instances with the target group
resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
  count             = 3
  target_group_arn  = aws_lb_target_group.my_target_group.arn
  target_id         = aws_instance.my_instance[count.index].id
  port              = 80
}

# Create a listener to forward traffic to the target group
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_target_group.arn
    type             = "forward"
  }
}

# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}
data "aws_availability_zones" "available" {
  state = "available"
}
