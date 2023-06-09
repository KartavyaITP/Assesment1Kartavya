# Retrieve the latest AMI IDs from the previous step
data "aws_ami" "kar-1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["kar-1"]
  }
}

# Create a Launch Configuration for the EC2 instances
resource "aws_launch_configuration" "my_launch_configuration" {
  name                 = "MyLaunchConfiguration"
  image_id             = data.aws_ami.kar-1
  instance_type        = var.instance_type     
  security_groups      = [aws_security_group.my_security_group.id]
  key_name             = "demo(key_pair1)"  
  

  
}

# Create an Auto Scaling Group using the Launch Configuration
resource "aws_autoscaling_group" "my_autoscaling_group" {
  name                 = "MyAutoScalingGroup"
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
  launch_configuration = aws_launch_configuration.my_launch_configuration.name

    scaling_policy {
    name                   = "ScaleInPolicy"
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = -1
    cooldown               = var.cooldown
    policy_type            = "SimpleScaling"
    estimated_instance_warmup = var.estimated_instance_warmup

    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 80
      scaling_adjustment         = 0
    }
    step_adjustment {
      metric_interval_lower_bound = var.metric_interval_lower_bound
      metric_interval_upper_bound = var.metric_interval_upper_bound
      scaling_adjustment         = -1
    }
  }

  scaling_policy {
    name                   = "ScaleOutPolicy"
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = 1
    cooldown               = 300
    policy_type            = "SimpleScaling"
    estimated_instance_warmup = 300

    metric_aggregation_type = "Average"
    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 80
      scaling_adjustment         = 1
    }
    step_adjustment {
      metric_interval_lower_bound = 80
      metric_interval_upper_bound = 100
      scaling_adjustment         = 0
    }
  }
}
