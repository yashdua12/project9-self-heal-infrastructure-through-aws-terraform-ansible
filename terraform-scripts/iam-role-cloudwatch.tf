data "aws_iam_policy_document" "cloudwatch_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "monitoring.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the CloudWatch IAM role
resource "aws_iam_role" "self_heal_cloudwatch_role" {
  name               = "self-heal-cloudwatch-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json

  tags = {
    Name = "self-heal-cloudwatch-role"
    Environment = "dev"
  }
}

# Attach AWS managed policy to the CloudWatch role

# Amazon SNS Full Access
resource "aws_iam_role_policy_attachment" "cloudwatch_sns_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  role       = aws_iam_role.self_heal_cloudwatch_role.name
}

# Output the role ARN
output "cloudwatch_role_arn" {
  description = "ARN of the CloudWatch IAM role"
  value       = aws_iam_role.self_heal_cloudwatch_role.arn
}