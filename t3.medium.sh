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

