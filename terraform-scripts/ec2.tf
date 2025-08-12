data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create 5 EC2 instances
# All instances will have the same configuration

resource "aws_instance" "self_heal_infra_ec2" {
  count = 5  # This creates 5 instances

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.self_heal_infra_kp.key_name
  
  # Attach the security group we created
  vpc_security_group_ids = [aws_security_group.self_heal_infra_sg.id]

  tags = {
    Name = "self-heal-infra-ec2-${count.index + 1}"  # This creates names like self-heal-infra-ec2-1, self-heal-infra-ec2-2, etc.
    Environment = "dev"
    Project = "self-heal"
  }
}

# Output the public IP addresses of all instances
output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.self_heal_infra_ec2[*].public_ip
}

# Output the instance IDs
output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.self_heal_infra_ec2[*].id
}