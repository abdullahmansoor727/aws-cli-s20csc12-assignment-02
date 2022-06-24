#!/bin/bash

ROOT_UID=0
E_NOTROOT=100
IMAGE_ID="ami-08d4ac5b634553e16"
INSTANCE_TYPE="t2.micro"
KEY_PAIR_NAME="assignment-02-kp"
SECURITY_GROUP_ID="$(aws ec2 describe-security-groups --group-names "assignment-02-sg" --query "SecurityGroups[0].GroupId" --output text)"
INSTANCE_NAME="website-server"
SUBNET_ID="$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=us-east-1c" --query "Subnets[0].SubnetId" --output text)"
USER_DATA=$(<user_data.txt)
/bin/bash ./task_01.sh
/bin/bash ./task_04.sh

if [[ "$UID" -ne "$ROOT_UID" ]];
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi
echo "Launching Instance ($INSTANCE_NAME)"

aws ec2 run-instances \
  --image-id $IMAGE_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_PAIR_NAME \
  --security-group-ids $SECURITY_GROUP_ID \
  --subnet-id $SUBNET_ID \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE_NAME"}]" \
  --user-data "$USER_DATA" &> /dev/null
  
echo "Instance Launched ($INSTANCE_NAME)"