data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Create the SNS topic
resource "aws_sns_topic" "self_heal_sns" {
  name = "self-heal-sns"

  tags = {
    Name        = "self-heal-sns"
    Environment = "dev"
    Purpose     = "CloudWatch notifications for self-heal infrastructure"
  }
}

# Create the access policy document
# This allows CloudWatch to publish messages to our SNS topic
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AllowCloudWatchToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }

    actions = ["sns:Publish"]

    resources = [aws_sns_topic.self_heal_sns.arn]
  }
}

# Attach the policy to the SNS topic
resource "aws_sns_topic_policy" "self_heal_sns_policy" {
  arn    = aws_sns_topic.self_heal_sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}


# Output the SNS topic ARN and name
output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.self_heal_sns.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic"
  value       = aws_sns_topic.self_heal_sns.name
}

output "sns_topic_policy" {
  description = "The policy applied to the SNS topic"
  value       = data.aws_iam_policy_document.sns_topic_policy.json
}