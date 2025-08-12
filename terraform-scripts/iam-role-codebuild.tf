data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the CodeBuild IAM role
resource "aws_iam_role" "self_heal_code_build_role" {
  name               = "self-heal-code-build-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = {
    Name = "self-heal-code-build-role"
    Environment = "dev"
  }
}

# Attach AWS managed policies to the CodeBuild role

# 1. Amazon S3 Full Access
resource "aws_iam_role_policy_attachment" "codebuild_s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.self_heal_code_build_role.name
}

# 2. Amazon SSM Full Access
resource "aws_iam_role_policy_attachment" "codebuild_ssm_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.self_heal_code_build_role.name
}

# 3. CloudWatch Logs Full Access
resource "aws_iam_role_policy_attachment" "codebuild_cloudwatch_logs_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role       = aws_iam_role.self_heal_code_build_role.name
}

# Output the role ARN
output "codebuild_role_arn" {
  description = "ARN of the CodeBuild IAM role"
  value       = aws_iam_role.self_heal_code_build_role.arn
}