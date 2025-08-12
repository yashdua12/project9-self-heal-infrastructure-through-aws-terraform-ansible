# project9-self-heal-infrastructure-through-aws-terraform-ansible
# Self-Heal Infrastructure through AWS, Terraform & Ansible

This project demonstrates how to automatically heal infrastructure using AWS services. When specific metrics of an EC2 instance reach a threshold, a Lambda function is triggered, and the CodeBuild service executes Ansible playbooks to heal the EC2 instances.

## Project Flow

1. **EC2 Instance**: Monitored for specific metrics.
2. **CloudWatch**: Observes metrics and triggers alarms.
3. **SNS Topic**: Receives notifications from CloudWatch.
4. **AWS Lambda**: Triggered by SNS notifications.
5. **CodeBuild**: Fetches and executes Ansible playbooks.
6. **S3 Bucket**: Stores Ansible playbooks.
7. **EC2 Instance Repaired**: Instances are healed through playbook execution.

## Detailed Explanation

1. **Watcher**: CloudWatch monitors EC2 instance metrics and triggers alarms when thresholds are breached.
2. **Messenger**: CloudWatch sends alerts to SNS (Simple Notification Service).
3. **Notification Delivery**: SNS delivers messages to its subscribers, in this case, AWS Lambda.
4. **Lambda Trigger**: AWS Lambda is triggered by SNS notifications and invokes CodeBuild.
5. **CodeBuild Execution**: CodeBuild fetches Ansible playbooks from an S3 bucket and executes them.
6. **Healing Process**: EC2 instances are healed each time CodeBuild runs the playbooks.

## Communication Between Services

AWS IAM roles with specific policies enable communication and actions between services.

## Infrastructure Setup

- **EC2 Instances**: 5 instances created.
- **S3 Bucket**: For storing playbooks.
- **IAM Roles**: Created with Terraform scripts.
- **SNS Topic**: Created with Terraform scripts.
- **AWS Lambda & CodeBuild**: Created manually via AWS Console.

## Running Terraform Scripts

1. Create an IAM user with administrator access.
2. Create AWS CLI access key.
3. Run the following commands:
   - `terraform init`
   - `terraform fmt`
   - `terraform plan`
   - `terraform apply`

## CodeBuild Configuration

In `buildspec.yml`, use the following code block (update with your S3 bucket credentials):

```yaml
version: 0.2

phases:
  install:
    commands:
      - echo Installing Ansible...
      - yum install -y python3-pip
      - pip3 install ansible
      - echo Downloading files from S3...
      - aws s3 cp s3://self-heal-infra-s3-bucket-01/self-heal-infra-scripts/ ./ --recursive
      - chmod 400 key.pem
  build:
    commands:
      - echo Running Ansible playbook...
      - ansible-playbook -i inventory.yml self_heal.yml

artifacts:
  files:
    - '**/*'
```

## IAM Roles and Policies

1. **self-heal-cloudwatch role**: Attach `AmazonSNSFullAccess`.
2. **self-heal-lambda role**: Attach `AWSLambdaBasicExecutionRole`, `AWSCodeBuildDeveloperAccess`, `AmazonS3FullAccess`, `AmazonSSMFullAccess`.
3. **self-heal-codebuild role**: Attach `AmazonS3FullAccess`, `AmazonSSMFullAccess`, `CloudWatchLogsFullAccess`.
4. **self-heal-ec2-role**: Attach `AmazonSSMManagedInstances`, `CloudWatchCoreAgentServerPolicy`.
5. Attach these roles to their respective services.
