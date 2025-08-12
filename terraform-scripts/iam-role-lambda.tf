data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Create the Lambda IAM role
resource "aws_iam_role" "self_heal_lambda_role" {
  name               = "self-heal-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = {
    Name = "self-heal-lambda-role"
    Environment = "dev"
  }
}

# Attach AWS managed policies to the Lambda role

# 1. AWS Lambda Basic Execution Role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.self_heal_lambda_role.name
}

# 2. AWS CodeBuild Developer Access
resource "aws_iam_role_policy_attachment" "lambda_codebuild_developer" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
  role       = aws_iam_role.self_heal_lambda_role.name
}

# 3. Amazon S3 Full Access
resource "aws_iam_role_policy_attachment" "lambda_s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.self_heal_lambda_role.name
}

# 4. Amazon SSM Full Access
resource "aws_iam_role_policy_attachment" "lambda_ssm_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role       = aws_iam_role.self_heal_lambda_role.name
}

# Output the role ARN
output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.self_heal_lambda_role.arn
}