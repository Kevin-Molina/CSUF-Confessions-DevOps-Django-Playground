terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "cluster.tfstate"
  }
}


data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "security-groups.tfstate"
  }
}

data "terraform_remote_state" "iam_roles" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "iam-roles.tfstate"
  }
}



resource "aws_key_pair" "key_pair" {
  key_name   = "kevin-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCwQQ+60APRosvqmFVS3Xew92I0d49P8AcPAj8efWYUxobAGxwuJyjArssSyGj7oYRB0eJimLE9kwpQOjKhfQ1gGrMteQAOI4NYcfAWW5Dew4dvTvhcW/tV+q+tax5uS5OxGE23D4smvnCbn10m8bUV+HYNt+11Jn43Fzn1oqMyLpEPjKFOQJe89fI1lGQ3iP6uhGyHbft3yfdlh1SYpGHZZjEyHhF51B9+wS84Pz5+ZJum71emDnSNN7T+hhE5xUg6mjfTJrGAinxyBb8qOrF+MUiZJIXVtvxYvZCtd+ctohUH7HfocJze0JJw/DDm5EVsuQDNWENzKc5caQWOL/m/kOVrGojmfIIFWepdmVIGG784G4cIH4vdqdGibM7CJ05HxepyHVKRgjjc5HwogO4R8ZAQfoVmwJ61mx4uFbf1oUkAGo43J+M8S6bpV582pPOfXPsPNGEoddQaX6fA1lYfnFKP2j1m1L4leSIvl7RykFUtHU7J6oj4Jfk8GQMK8meVN1M11KPaRhFVZAQ4WyEXhU3I/rM/FXWz8YweEz/o0pKFBf3qQ2Xpo1k826EBnL9WanqXCALNGmL7lPIH5ScbFmrTpYXrzFqGbUvIje9xwH82Egkm5RPI0OVQ8PcRvqYf+h0wjb3KSACaN/A0uah9LnmzK1+7z8rFdJmam9DuEw== kevin.molina@csu.fullerton.edu"
}

resource "aws_placement_group" "placement_group" {
  name     = "app-placement-group"
  strategy = "spread"
}

resource "aws_launch_template" "launch_template" {
  name = "launch-template"

  iam_instance_profile {
    name = data.terraform_remote_state.iam_roles.outputs.ecs_instance_profile
  }

  image_id = "ami-test"
  instance_type = "t3a.nano"
  instance_initiated_shutdown_behavior = "terminate"

  key_name = aws_key_pair.key_pair.public_key
  vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.app_sg_id]


  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    group_name = aws_placement_group.placement_group.name
  }

}


resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "ASG"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  placement_group           = aws_placement_group.placement_group.name
  vpc_zone_identifier       = [data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1a, 
                               data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1b, 
                               data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1c]

  launch_template {
      id      = aws_launch_template.launch_template.id
      version = "$Latest"
  }

  timeouts {
    delete = "10m"
  }
}