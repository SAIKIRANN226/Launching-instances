#!/bin/bash

# Define variables
REGION="us-east-1"                    # Set the AWS region
AMI_ID="ami-0b4f379183e5706b9"        # Set the AMI ID (Change to the desired AMI)
INSTANCE_TYPE="t2.micro"              # Set the instance type (e.g., t2.micro)
#KEY_NAME="my-key-pair"                # Set the name of your EC2 key pair
SECURITY_GROUP="my-security-group"    # Set the security group
TAG_NAME="MyEC2Instance"              # Set a name for your EC2 instance

# Storage Configuration (EBS volume)
VOLUME_SIZE=8                        # Size of the root volume in GB
VOLUME_TYPE="gp3"                    # Volume type (e.g., gp3 for general purpose SSD)
IOPS=300                             # IOPS for the volume (only for provisioned IOPS volumes like io1/io2)
THROUGHPUT=125                       # Throughput in MB/s for gp3 volumes

# Create EC2 instance with attached storage
INSTANCE_ID=$(aws ec2 run-instances \
    --region "$REGION" \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
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

# Output instance ID, public IP address, and storage size
echo "EC2 instance launched successfully!"
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "Storage Size: $VOLUME_SIZE GB"
