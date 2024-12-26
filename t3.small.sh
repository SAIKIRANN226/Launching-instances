EC2_NAME="first"
AMI_NAME="Centos-8-DevOps-Practice"
INSTANCE_TYPE="t3.medium"
STORAGE_SIZE=30
SECURITY_GROUP_ID="sg-062184d660bab16ba"


AMI_ID=$(aws ec2 describe-images \
  --filters "Name=name,Values=$AMI_NAME" \
  --query "Images[0].ImageId" \
  --output text)

if [ "$AMI_ID" == "None" ]; then
  echo "AMI '$AMI_NAME' not found."
  exit 1
else
  echo "Found AMI: $AMI_ID"
fi

echo "Launching EC2 instance with name: $EC2_NAME"


INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --associate-public-ip-address \
  --block-device-mappings "DeviceName=/dev/sda1,Ebs={VolumeSize=$STORAGE_SIZE}" \
  --output text)

echo "EC2 instance launched with ID: $INSTANCE_ID"
