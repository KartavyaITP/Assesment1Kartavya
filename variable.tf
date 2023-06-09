variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

variable "ami" {
    type = string
    default = "ami-04a0ae173da5807d3"
}

variable "desired_capacity" {
    type = number
    default = 3
  
}

variable "min_size" {
    type = number
    default = 3
  
}

variable "max_size" {
    type = number
    default = 5
  
}

variable "cooldown" {
    type = number
    default = 300
  
}

variable "estimated_instance_warmup" {
    type = number
    default = 300
  
}

variable "metric_interval_upper_bound" {
    type = number
    default = 300
  
}

variable " metric_interval_lower_bound" {
    type = number
    default = 80
  
}

variable " metric_interval_upper_bound" {
    type = number
    default = 100
  
}

