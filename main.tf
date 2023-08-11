

resource "aws_security_group" "app_sg" {

  name        = "app-sg"
  description = "Allow HTTP or HTTPs"


  ingress {
    description = "allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # mysecurity_groups = [ aws_security_group.lb_sg.id ]
    # should we use the security group cidr block rejected/deleted 

  }

  ingress {
    description = "Allow HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # mysecurity_groups = [ aws_security_group.lb_sg.id ]
    # should we use the security group cidr block rejected/deleted 
  }

  egress {
    description = "allow outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # mysecurity_groups = [ aws_security_group.lb_sg.id]

  }
  vpc_id = aws_vpc.application_vpc.id
}

resource "aws_key_pair" "key" {
  key_name   = "vm_keypair"
  public_key = file("~/.ssh/ec2.pub")

}
