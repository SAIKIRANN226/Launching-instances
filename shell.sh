#!/bin/bash

EC2_NAME="sai_ec2"   
AMI_ID="ami-0b4f379183e5706b9"  
INSTANCE_TYPE="t2.micro"      
STORAGE_SIZE=8               
SECURITY_GROUP_ID="sg-062184d660bab16ba"  

# Block device mapping for the root volume
# BLOCK_DEVICE_MAPPING="DeviceName=/dev/sda1,Ebs={VolumeSize=$STORAGE_SIZE}"

echo "Launching EC2 instance with name: $EC2_NAME"

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --associate-public-ip-address \
  --query 'Instances[0].InstanceId' \
  --output text)


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
