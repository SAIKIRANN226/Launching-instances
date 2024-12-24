#!/bin/bash

AMI_ID=$(aws ec2 describe-images \
  --filters "Name=name,Values=Centos-8-DevOps-Practice" \
  --query "Images[0].ImageId" \
  --output text)


if [ "$AMI_ID" == "None" ]; then
  echo "Error: AMI 'Centos-8-DevOps-Practice' not found."
  exit 1
fi


INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t3.medium \
  --security-group-ids ssg-062184d660bab16ba \
  --region us-east-1 \
  --count 1 \
  --block-device-mappings = /dev/xvda,Ebs={VolumeSize=30} \
  --query 'Instances[0].InstanceId' \
  --output text)
