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

# ---------- HELPERS ----------
FUNCTION log(message):
    PRINT current_timestamp + " " + message

FUNCTION fail(message):
    log("ERROR: " + message)
    EXIT with code 1

# ---------- STEP 1: PREREQUISITES ----------
FUNCTION check_prerequisites():
    IF aws CLI is not installed:
        fail("AWS CLI missing")
    IF "aws sts get-caller-identity" fails:
        fail("Invalid AWS credentials")

# ---------- STEP 2: VALIDATE INPUTS ----------
FUNCTION validate_inputs():
    IF AMI_ID, KEY_NAME, SECURITY_GROUP, or SUBNET_ID is empty:
        fail("Missing required parameter")
    IF INSTANCE_COUNT is not a positive integer:
        fail("Invalid instance count")
    IF AMI_ID not found via "describe-images":
        fail("AMI not found in region")
    IF KEY_NAME not found via "describe-key-pairs":
        fail("Key pair not found")
    IF SECURITY_GROUP not found via "describe-security-groups":
        fail("Security group not found")
    IF SUBNET_ID not found via "describe-subnets":
        fail("Subnet not found")

# ---------- STEP 3: CREATE INSTANCES ----------
FUNCTION create_instances():
    log("Launching " + INSTANCE_COUNT + " instance(s)")
    RUN "aws ec2 run-instances" WITH
        image-id, instance-type, key-name,
        security-group-ids, subnet-id,
        count = INSTANCE_COUNT,
        tags = Name=NAME_TAG
    IF command fails:
        fail("run-instances failed")
    EXTRACT instance IDs from response
    IF instance ID list is empty:
        fail("No instance IDs returned")
    RETURN instance ID list

# ---------- STEP 4: WAIT ----------
FUNCTION wait_until_running(instance_ids):
    log("Waiting for instances to reach running state")
    RUN "aws ec2 wait instance-running" FOR instance_ids
    IF wait exceeds WAIT_TIMEOUT or fails:
        fail("Instances did not reach running state in time")

# ---------- STEP 5: REPORT ----------
FUNCTION report(instance_ids):
    FOR EACH id IN instance_ids:
        QUERY state, private IP, public IP via "describe-instances"
        PRINT id, state, private IP, public IP

# ---------- MAIN ----------
check_prerequisites()
validate_inputs()
ids = create_instances()
wait_until_running(ids)
report(ids)
log("Done")