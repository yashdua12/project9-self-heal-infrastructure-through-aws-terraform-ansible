# =============================================================================
# S3 Bucket Configuration for Self-Heal Infrastructure
# =============================================================================
# This script creates an S3 bucket and uploads ansible scripts for automation

# Create the S3 bucket
resource "aws_s3_bucket" "self_heal_bucket" {
  bucket = "self-heal-infra-bucket01"

  tags = {
    Name        = "self-heal-infra-bucket01"
    Environment = "dev"
    Purpose     = "Storage for self-heal infrastructure scripts"
    Project     = "self-heal-automation"
  }
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "self_heal_bucket_versioning" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "self_heal_bucket_encryption" {
  bucket = aws_s3_bucket.self_heal_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "self_heal_bucket_pab" {
  bucket = aws_s3_bucket.self_heal_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# =============================================================================
# Upload Ansible Scripts to S3 Bucket
# =============================================================================

# Upload ansible.cfg
resource "aws_s3_object" "ansible_cfg" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  key    = "ansible-scripts/ansible.cfg"
  source = "${path.module}/ansible-scripts/ansible.cfg"
  etag   = filemd5("${path.module}/ansible-scripts/ansible.cfg")

  tags = {
    Name = "ansible-config"
    Type = "configuration"
  }
}

# Upload inventory.yml
resource "aws_s3_object" "inventory_yml" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  key    = "ansible-scripts/inventory.yml"
  source = "${path.module}/ansible-scripts/inventory.yml"
  etag   = filemd5("${path.module}/ansible-scripts/inventory.yml")

  tags = {
    Name = "ansible-inventory"
    Type = "configuration"
  }
}

# Upload self_heal.yml playbook
resource "aws_s3_object" "self_heal_yml" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  key    = "ansible-scripts/self_heal.yml"
  source = "${path.module}/ansible-scripts/self_heal.yml"
  etag   = filemd5("${path.module}/ansible-scripts/self_heal.yml")

  tags = {
    Name = "ansible-playbook"
    Type = "playbook"
  }
}

# Upload key.pem (SSH key)
resource "aws_s3_object" "key_pem" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  key    = "ansible-scripts/key.pem"
  source = "${path.module}/ansible-scripts/key.pem"
  etag   = filemd5("${path.module}/ansible-scripts/key.pem")

  tags = {
    Name = "ssh-key"
    Type = "credential"
  }
}

# Upload ansible.log (if it exists)
resource "aws_s3_object" "ansible_log" {
  bucket = aws_s3_bucket.self_heal_bucket.id
  key    = "ansible-scripts/ansible.log"
  source = "${path.module}/ansible-scripts/ansible.log"
  etag   = filemd5("${path.module}/ansible-scripts/ansible.log")

  tags = {
    Name = "ansible-log"
    Type = "log"
  }
}

# =============================================================================
# Outputs
# =============================================================================

# Output the bucket name
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.self_heal_bucket.id
}

# Output the bucket ARN
output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.self_heal_bucket.arn
}

# Output the bucket domain name
output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.self_heal_bucket.bucket_domain_name
}

# Output the uploaded files
output "uploaded_ansible_files" {
  description = "List of uploaded ansible files"
  value = [
    aws_s3_object.ansible_cfg.key,
    aws_s3_object.inventory_yml.key,
    aws_s3_object.self_heal_yml.key,
    aws_s3_object.key_pem.key,
    aws_s3_object.ansible_log.key
  ]
}