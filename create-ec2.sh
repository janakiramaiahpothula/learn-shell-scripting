
#!/bin/bash

set -Eeuo pipefail

# AWS configuration
AWS_REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"
INSTANCE_TYPE="t3.micro"
KEY_NAME="my-keypair"
SECURITY_GROUP_ID="sg-0cadca73f7bd058f6"
INSTANCE_COUNT=3
INSTANCE_NAME="My-Web-Server"

# Check AWS CLI installation
if ! command -v aws >/dev/null 2>&1; then
    echo "ERROR: AWS CLI is not installed."
    exit 1
fi

# Verify AWS credentials
if ! aws sts get-caller-identity \
    --region "$AWS_REGION" >/dev/null 2>&1; then
    echo "ERROR: AWS credentials are invalid."
    exit 1
fi

# Validate required configuration
if [[ ! "$INSTANCE_COUNT" =~ ^[1-9][0-9]*$ ]] ||
   [[ "$INSTANCE_NAME" == *$'\n'* ]]; then
    echo "ERROR: Invalid instance count or name."
    exit 1
fi

# Launch EC2 instance(s) and assign Name tag
INSTANCE_IDS=$(aws ec2 run-instances \
    --region "$AWS_REGION" \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SECURITY_GROUP_ID" \
    --count "$INSTANCE_COUNT" \
    --tag-specifications \
    "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --query 'Instances[].InstanceId' \
    --output text)

echo "Created instance ID(s): $INSTANCE_IDS"

# Wait until each instance is running
for ID in $INSTANCE_IDS; do
    aws ec2 wait instance-running \
        --region "$AWS_REGION" \
        --instance-ids "$ID"

    echo "Instance $ID is running."
done

# Display instance details
aws ec2 describe-instances \
    --region "$AWS_REGION" \
    --instance-ids $INSTANCE_IDS \
    --query 'Reservations[].Instances[].{
        InstanceId:InstanceId,
        Name:Tags[?Key==`Name`]|[0].Value,
        State:State.Name,
        PrivateIP:PrivateIpAddress,
        PublicIP:PublicIpAddress
    }' \
    --output table

echo "SUCCESS: EC2 instance creation completed."
