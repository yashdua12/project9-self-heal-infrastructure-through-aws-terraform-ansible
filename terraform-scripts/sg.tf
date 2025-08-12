resource "aws_security_group" "self_heal_infra_sg" {
  name        = "self-heal-infra-sg"
  description = "Security group for self heal infrastructure"

  # SSH access from anywhere IPv4
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from anywhere IPv4"
  }

  # SSH access from anywhere IPv6
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    description      = "SSH access from anywhere IPv6"
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "All outbound traffic"
  }

  tags = {
    Name = "self-heal-infra-sg"
    Environment = "dev"
  }
}