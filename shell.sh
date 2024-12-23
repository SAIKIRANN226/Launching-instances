#!/bin/bash

# Ensure correct number of arguments are passed
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <ec2_name>"
  exit 1
fi

# Get arguments
EC2_NAME=$1

# Community AMI name (Centos-8-DevOps-Practice)
AMI_NAME="Centos-8-DevOps-Practice"

# Instance type (t2.micro)
INSTANCE_TYPE="t2.micro"

# EBS volume size (30 GiB)
STORAGE_SIZE=30

# Find the AMI ID based on the provided AMI name
AMI_ID=$(aws ec2 describe-images \
  --filters "Name=name,Values=$AMI_NAME" \
  --query "Images[0].ImageId" \
  --output text)

# Check if AMI was found
if [ "$AMI_ID" == "None" ]; then
  echo "AMI with the name '$AMI_NAME' not found."
  exit 1
else
  echo "Found AMI: $AMI_ID"
fi

# Launch the EC2 instance using the provided details
echo "Launching EC2 instance with name: $EC2_NAME"

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$STORAGE_SIZE}" \
  --count 1 \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$EC2_NAME}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

# Check if instance creation was successful
if [ "$INSTANCE_ID" == "None" ]; then
  echo "Failed to launch EC2 instance."
  exit 1
else
  echo "EC2 instance launched successfully. Instance ID: $INSTANCE_ID"
fi

# Fetch the public IP of the instance
INSTANCE_PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

if [ "$INSTANCE_PUBLIC_IP" == "None" ]; then
  echo "Unable to fetch the public IP address of the instance."
  exit 1
else
  echo "Public IP address of the instance: $INSTANCE_PUBLIC_IP"
fi

# Provide SSH details (assuming no key-pair)
echo "You can now SSH into the instance using the following command (password-based SSH required):"
echo "ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_PUBLIC_IP"
