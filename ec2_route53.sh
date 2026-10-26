#!/bin/bash

# EC2 and Route 53 Automation Script

# AWS Configuration
AWS_REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"
INSTANCE_TYPE="t2.micro"
KEY_NAME="my-key"
SECURITY_GROUP_ID="sg-0cadca73f7bd058f6"

# Route 53 Configuration
HOSTED_ZONE_ID="Z07286093DGE50OVDUT7O"
DNS_RECORD_NAME="classpractice.online"

# Check AWS CLI
if ! command -v aws >/dev/null 2>&1; then
    echo "Error: AWS CLI is not installed."
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "Error: AWS credentials are not configured."
    exit 1
fi

# Display Menu
echo "=================================="
echo " EC2 and Route 53 Automation"
echo "=================================="
echo "1. Create EC2 Instance"
echo "2. Delete EC2 Instance"
echo "3. Update Route 53 Record"
echo "4. Exit"

read -r -p "Enter your choice: " choice

case "$choice" in

1)
    echo "Creating EC2 instance..."

    INSTANCE_ID=$(aws ec2 run-instances \
        --region "$AWS_REGION" \
        --image-id "$AMI_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --key-name "$KEY_NAME" \
        --security-group-ids "$SECURITY_GROUP_ID" \
        --count 1 \
        --query 'Instances[0].InstanceId' \
        --output text) || {
            echo "Error: Failed to create EC2 instance."
            exit 1
        }

    echo "Instance ID: $INSTANCE_ID"

    echo "Waiting for instance to start..."

    aws ec2 wait instance-running \
        --region "$AWS_REGION" \
        --instance-ids "$INSTANCE_ID" || {
            echo "Error: Instance did not reach running state."
            exit 1
        }

    PUBLIC_IP=$(aws ec2 describe-instances \
        --region "$AWS_REGION" \
        --instance-ids "$INSTANCE_ID" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text) || exit 1

    echo "Instance is running."
    echo "Instance ID: $INSTANCE_ID"
    echo "Public IP: $PUBLIC_IP"
    ;;

2)
    read -r -p "Enter EC2 Instance ID: " INSTANCE_ID

    if [[ ! "$INSTANCE_ID" =~ ^i-[a-fA-F0-9]+$ ]]; then
        echo "Error: Invalid instance ID format."
        exit 1
    fi

    echo "WARNING: This will terminate instance $INSTANCE_ID."
    read -r -p "Type YES to confirm deletion: " CONFIRM

    if [[ "$CONFIRM" == "YES" ]]; then

        aws ec2 terminate-instances \
            --region "$AWS_REGION" \
            --instance-ids "$INSTANCE_ID" || {
                echo "Error: Failed to terminate instance."
                exit 1
            }

        echo "Waiting for instance termination..."

        aws ec2 wait instance-terminated \
            --region "$AWS_REGION" \
            --instance-ids "$INSTANCE_ID" || {
                echo "Error: Termination is not yet confirmed."
                exit 1
            }

        echo "EC2 instance terminated successfully."

    else
        echo "Deletion cancelled."
    fi
    ;;

3)
    read -r -p "Enter EC2 Instance ID: " INSTANCE_ID

    if [[ ! "$INSTANCE_ID" =~ ^i-[a-fA-F0-9]+$ ]]; then
        echo "Error: Invalid instance ID format."
        exit 1
    fi

    PUBLIC_IP=$(aws ec2 describe-instances \
        --region "$AWS_REGION" \
        --instance-ids "$INSTANCE_ID" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text) || {
            echo "Error: Could not retrieve instance details."
            exit 1
        }

    if [[ ! "$PUBLIC_IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] ||
       [[ "$PUBLIC_IP" == "0.0.0.0" ]]; then
        echo "Error: Instance has no usable public IPv4 address."
        exit 1
    fi

    echo "Instance public IP: $PUBLIC_IP"
    echo "DNS record: $DNS_RECORD_NAME"

    read -r -p "Update this DNS record? Type YES: " CONFIRM

    if [[ "$CONFIRM" != "YES" ]]; then
        echo "DNS update cancelled."
        exit 0
    fi

    # Create Route 53 change request
    CHANGE_FILE=$(mktemp) || exit 1

    trap 'rm -f "$CHANGE_FILE"' EXIT

    cat > "$CHANGE_FILE" <<EOF
{
  "Comment": "Update EC2 public IP",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "$DNS_RECORD_NAME",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$PUBLIC_IP"
          }
        ]
      }
    }
  ]
}
EOF

    echo "Updating Route 53 record..."

    CHANGE_ID=$(aws route53 change-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-batch "file://$CHANGE_FILE" \
        --query 'ChangeInfo.Id' \
        --output text) || {
            echo "Error: Route 53 update failed."
            exit 1
        }

    echo "DNS change submitted: $CHANGE_ID"

    if aws route53 wait resource-record-sets-changed \
        --id "$CHANGE_ID"; then
        echo "Route 53 DNS update completed."
        echo "Record: $DNS_RECORD_NAME"
        echo "New IP: $PUBLIC_IP"
    else
        echo "DNS change was submitted, but propagation status is not confirmed."
        exit 1
    fi
    ;;

4)
    echo "Exiting script."
    exit 0
    ;;

*)
    echo "Invalid choice. Please select 1, 2, 3, or 4."
    exit 1
    ;;

esac
