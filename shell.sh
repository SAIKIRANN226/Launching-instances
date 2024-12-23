#!/bin/bash

if [ "$#" -lt 4 ]; then
  echo "Usage: $0 <ec2_name> <instance_type> <storage_size> <security_group_id>"
  exit 1
fi


EC2_NAME=$1
INSTANCE_TYPE=$2
STORAGE_SIZE=$3
SECURITY_GROUP_ID=$4

AMI_NAME="Centos-8-DevOps-Practice"


AMI_ID=$(aws ec2 describe-images \
  --filters "Name=name,Values=$AMI_NAME" \
  --query "Images[0].ImageId" \
  --output text)


if [ "$AMI_ID" == "None" ]; then
  echo "AMI with the name '$AMI_NAME' not found."
  exit 1
else
  echo "Found AMI: $AMI_ID"
fi


echo "Launching EC2 instance with name: $EC2_NAME"

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$STORAGE_SIZE}" \
  --count 1 \
  --associate-public-ip-address \
  --tag "Key=Name,Value=$EC2_NAME" \
  --query 'Instances[0].InstanceId' \
  --output text)


if [ "$INSTANCE_ID" == "None" ]; then
  echo "Failed to launch EC2 instance."
  exit 1
else
  echo "EC2 instance launched successfully. Instance ID: $INSTANCE_ID"
fi


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


echo "You can now SSH into the instance using the following command (password-based SSH required):"
echo "ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_PUBLIC_IP"
