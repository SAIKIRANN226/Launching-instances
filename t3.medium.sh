#!/bin/bash

EC2_NAME="MyEC2Instance"  
AMI_NAME="Centos-8-DevOps-Practice" 
INSTANCE_TYPE="t3.medium"  
SECURITY_GROUP_ID="ssg-062184d660bab16ba" 
KEY_PAIR=""  
STORAGE_SIZE=30 


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=$AMI_NAME" --query "Images[0].ImageId" --output text)


if [ "$AMI_ID" == "None" ]; then
    echo "AMI with name '$AMI_NAME' not found. Exiting..."
    exit 1
fi


INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --security-group-ids $SECURITY_GROUP_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$EC2_NAME}]" \
    --key-name "$KEY_PAIR" \
    --query "Instances[0].InstanceId" \
    --output text)

# Check if the instance was launched successfully
if [ "$INSTANCE_ID" == "None" ]; then
    echo "Failed to launch EC2 instance. Exiting..."
    exit 1
else
    echo "EC2 instance $EC2_NAME (ID: $INSTANCE_ID) has been successfully launched."
fi
