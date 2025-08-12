import boto3
import json

# Hardcoded list of EC2 instance IDs
INSTANCE_IDS = ["i-0221a27f17dcc3ef6", "i-0b1d2760dad9d6ba2","i-040570c32d71e1ec4","i-05224e82c03d4421b","i-0a833e74313116e0d"]

# Placeholder CodeBuild project name
CODEBUILD_PROJECT = "self-heal-code-build"

# Initialize AWS clients
ec2_client = boto3.client('ec2')
codebuild_client = boto3.client('codebuild')

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    try:
        # 1. Start EC2 instances
        print(f"Starting EC2 instances: {INSTANCE_IDS}")
        ec2_client.start_instances(InstanceIds=INSTANCE_IDS)
        print("EC2 instances start initiated.")

        # 2. Trigger CodeBuild project
        print(f"Starting CodeBuild project: {CODEBUILD_PROJECT}")
        codebuild_client.start_build(projectName=CODEBUILD_PROJECT)
        print("CodeBuild start initiated.")

        return {
            'statusCode': 200,
            'body': json.dumps('EC2 started & CodeBuild triggered successfully.')
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error occurred: ' + str(e))
        }
