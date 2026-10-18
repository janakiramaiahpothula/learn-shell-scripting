#!/bin/bash
set -euo pipefail

# ---------- CONFIG ----------
REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"
INSTANCE_TYPE="t3.micro"
KEY_NAME="my-key"
SG_ID="sg-05527c794e4caf5a3"
#SUBNET_ID="subnet-xxxxxxxx"
HOSTED_ZONE_ID="Z07286093DGE50OVDUT7O"
DOMAIN="classpractice.online"
TTL=1

# ---------- FUNCTIONS ----------

function log(msg):
    print timestamp + msg

function check_prerequisites():
    if aws CLI not installed:
        log "AWS CLI missing"; exit 1
    if "aws sts get-caller-identity" fails:
        log "Invalid AWS credentials"; exit 1

function create_instances(count):
    INSTANCE_IDS = aws ec2 run-instances
                      --image-id AMI_ID
                      --instance-type INSTANCE_TYPE
                      --key-name KEY_NAME
                      --security-group-ids SG_ID
                      --subnet-id SUBNET_ID
                      --count count
                      --tag-specifications Name=<tag>
                      --query 'Instances[*].InstanceId'
    if INSTANCE_IDS empty:
        log "Creation failed"; exit 1
    aws ec2 wait instance-running --instance-ids INSTANCE_IDS
    return INSTANCE_IDS

function get_ips(instance_ids):
    return aws ec2 describe-instances
              --instance-ids instance_ids
              --query 'Reservations[*].Instances[*].PublicIpAddress'

function update_route53(action, ip_list):
    build JSON change batch:
        Action = action            # UPSERT or DELETE
        Name   = DOMAIN
        Type   = "A"
        TTL    = TTL
        ResourceRecords = [ {Value: ip} for ip in ip_list ]
    CHANGE_ID = aws route53 change-resource-record-sets
                   --hosted-zone-id HOSTED_ZONE_ID
                   --change-batch JSON
    loop:
        STATUS = aws route53 get-change --id CHANGE_ID
        if STATUS == "INSYNC": break
        sleep 10

function find_instances_by_tag(tag):
    return aws ec2 describe-instances
              --filters Name=tag:Name,Values=tag
                        Name=instance-state-name,Values=running
              --query 'Reservations[*].Instances[*].InstanceId'

function delete_instances(instance_ids):
    if instance_ids empty:
        log "No instances found"; return
    IPS = get_ips(instance_ids)
    update_route53("DELETE", IPS)
    aws ec2 terminate-instances --instance-ids instance_ids
    aws ec2 wait instance-terminated --instance-ids instance_ids

# ---------- MAIN ----------

ACTION = $1
check_prerequisites()

switch ACTION:
    case "create":
        COUNT = $2 or 1
        IDS = create_instances(COUNT)
        IPS = get_ips(IDS)
        update_route53("UPSERT", IPS)
        log "Created: IDS"

    case "delete":
        IDS = find_instances_by_tag(TAG_NAME)
        delete_instances(IDS)
        log "Deleted: IDS"

    case "update-dns":
        IDS = find_instances_by_tag(TAG_NAME)
        IPS = get_ips(IDS)
        update_route53("UPSERT", IPS)

    default:
        print "Usage: script.sh {create|delete|update-dns} [count]"
        exit 1