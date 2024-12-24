#!/bin/bash

REGION="us-east-1"                    
AMI_ID="ami-0c55b159cbfafe1f0"        
INSTANCE_TYPE="t2.micro"              
SECURITY_GROUP="ssg-062184d660bab16ba"   
TAG_NAME="MyEC2Instance"              

# Storage Configuration (EBS volume)
VOLUME_SIZE=30                        
VOLUME_TYPE="gp3"                    
IOPS=300                             
THROUGHPUT=125                       


INSTANCE_ID=$(aws ec2 run-instances \
    --region "$REGION" \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-groups "$SECURITY_GROUP" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --block-device-mappings \
        "DeviceName=/dev/sda1,Ebs={VolumeSize=$VOLUME_SIZE,VolumeType=$VOLUME_TYPE,Iops=$IOPS,Throughput=$THROUGHPUT}" \
    --count 1 \
    --output json \
    --query 'Instances[0].InstanceId')

# Wait for the instance to be running
echo "Waiting for EC2 instance to be running..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --output text)

# Output instance ID and public IP address
echo "EC2 instance launched successfully!"
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "Storage Size: $VOLUME_SIZE GB"
