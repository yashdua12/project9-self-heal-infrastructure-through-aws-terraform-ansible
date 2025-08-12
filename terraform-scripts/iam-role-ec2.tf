resource "aws_iam_role_policy_attachment" "ec2_ssm_managed_instance" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.self_heal_ec2_role.name
}

# 2. CloudWatch Agent Server Policy
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_agent_server" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.self_heal_ec2_role.name
}

# Create an instance profile for EC2 instances
# EC2 instances need an instance profile to use IAM roles
resource "aws_iam_instance_profile" "self_heal_ec2_profile" {
  name = "self-heal-ec2-profile"
  role = aws_iam_role.self_heal_ec2_role.name

  tags = {
    Name = "self-heal-ec2-profile"
    Environment = "dev"
  }
}

# Output the role ARN and instance profile name
output "ec2_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.self_heal_ec2_role.arn
}
