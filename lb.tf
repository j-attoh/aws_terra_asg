

resource "aws_lb" "app_lb" {

  name = "app-lb"

  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnets[*].id
  security_groups    = [aws_security_group.lb_sg.id]


}

resource "aws_lb_listener" "http_listener" {

  protocol = "HTTP"
  port     = 80

  load_balancer_arn = aws_lb.app_lb.arn


  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.lb_tg.arn
      }

    }
  }

}

resource "aws_lb_target_group" "lb_tg" {
  name     = "app-lb-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.application_vpc.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 30
    interval            = 40
  }

}

# resource "aws_lb_target_group_attachment" "tg_attach" {
#   count            = length(var.public_cidrs)
#   target_group_arn = aws_lb_target_group.lb_tg.arn
#   target_id        = element(aws_instance.vm[*].id, count.index)

# }


resource "aws_security_group" "lb_sg" {

  name        = "lb-sg"
  description = "Security Group for LoadBalancer"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "Allow HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.application_vpc.id

}
