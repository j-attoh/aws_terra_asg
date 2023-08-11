resource "aws_launch_template" "lt" {

  name          = "app-launch-template"
  instance_type = "t2.micro"
  image_id      = "ami-06e85d4c3149db26a"
  key_name      = aws_key_pair.key.key_name
  user_data     = filebase64("code.sh")
  iam_instance_profile {
    name = "S3DynamoDBFullAccessRole"
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }
  # myvpc_security_group_ids = [ aws_security_group.app_sg.id] 
}

resource "aws_autoscaling_group" "asg" {
  name = "app-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  launch_template {
    id = aws_launch_template.lt.id
  }
  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  target_group_arns   = [aws_lb_target_group.lb_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  default_instance_warmup = 300

  lifecycle {
    # respect dynamic scaling operations 
    ignore_changes = [
      desired_capacity, target_group_arns
    ]
  }

}


# resource aws_autoscaling_policy target_tracking
# name  = "target_tracking_scaling_policy"
resource "aws_autoscaling_policy" "taregt_tracking" {

  name                   = "target_tracking_scaling"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"

    }
    target_value = 60
  }


}


resource "aws_autoscaling_notification" "name" {

  group_names = [
    aws_autoscaling_group.asg.name
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = aws_sns_topic.asg_topic.arn
}

resource "aws_sns_topic" "asg_topic" {
  name = "app_directory_topic"

}

resource "aws_sns_topic_subscription" "asg_notification" {
  protocol  = "email"
  endpoint  = "attoh.attram@gmail.com"
  topic_arn = aws_sns_topic.asg_topic.arn

}
