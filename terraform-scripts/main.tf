provider "aws" {
  region = var.aws_region
  
  # Add default tags to all resources
  default_tags {
    tags = {
      Project     = "self-heal-infrastructure"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# Variables
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"  # Change this to your preferred region
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}