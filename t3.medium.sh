#!/bin/bash

INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $(aws ec2 describe-images --filters "Name=name,Values=Centos-8-DevOps-Practice" --query "Images[0].ImageId" --output text) \
  --instance-type t3.medium \
  --security-group-ids ssg-062184d660bab16ba \
  --no-key-name \
  --region us-east-1 \
  --count 1 \
  --block-device-mappings DeviceName=/dev/sda1,Ebs={VolumeSize=30} \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=EC2-1}]' \
  --query 'Instances[0].InstanceId' \
  --output text)


if [ "$INSTANCE_ID" == "None" ]; then
  echo "Error: Instance launch failed."
  exit 1
fi

# Wait for the instance to be in 'running' state
echo "Waiting for instance to be in 'running' state..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region us-east-1

# Retrieve the public IP of the instance
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text \
  --region us-east-1)

echo "EC2 instance launched successfully."
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
