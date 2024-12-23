#!/bin/bash

# Ensure correct number of arguments are passed
if [ "$#" -lt 5 ]; then
  echo "Usage: $0 <ec2_name> <ami_name> <instance_type> <security_group_id> <storage_size> [<tag_key1> <tag_value1> ...]"
  exit 1
fi

# Get arguments
EC2_NAME=$1
AMI_NAME=$2
INSTANCE_TYPE=$3
SECURITY_GROUP_ID=$4
STORAGE_SIZE=$5

# Fetch any additional tags from the arguments
TAGS=()
for ((i = 6; i <= $#; i+=2)); do
  TAG_KEY=${!i}
  TAG_VALUE=${!((i+1))}
  TAGS+=("Key=$TAG_KEY,Value=$TAG_VALUE")
done

# Find the AMI ID based on the provided name (e.g., "Centos-8-DevOps-Practice")
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

# Create EC2 instance using the provided details
echo "Launching EC2 instance with name: $EC2_NAME"

# Create the instance with tags, instance type, security group, and storage
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$STORAGE_SIZE}" \
  --count 1 \
  --associate-public-ip-address \
  --tag "Key=Name,Value=$EC2_NAME" \
  "${TAGS[@]/#/--tag }" \
  --query 'Instances[0].InstanceId' \
  --output text)

# Check if instance creation was successful
if [ "$INSTANCE_ID" == "None" ]; then
  echo "Failed to launch EC2 instance."
  exit 1
else
  echo "EC2 instance launched successfully. Instance ID: $INSTANCE_ID"
fi

# Fetch public IP of the instance
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

# Provide SSH details (without key-pair)
echo "You can now SSH into the instance using the following command (password-based SSH required):"
echo "ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_PUBLIC_IP"
