#!/bin/bash

ROOT_UID=0
E_NOTROOT=100
IMAGE_ID="ami-08d4ac5b634553e16"
INSTANCE_TYPE="t2.micro"
KEY_PAIR_NAME="assignment-02-kp"
SECURITY_GROUP_ID="$(aws ec2 describe-security-groups --group-names "assignment-02-sg" --query "SecurityGroups[0].GroupId" --output text)"

INSTANCE_01_NAME="ubuntu-server-01"
INSTANCE_02_NAME="ubuntu-server-02"
SUBNET_ID_01="$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=us-east-1a" --query "Subnets[0].SubnetId" --output text)"
SUBNET_ID_02="$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=us-east-1b" --query "Subnets[0].SubnetId" --output text)"


if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

/bin/bash ./task_04.sh

echo "Launching Instance 01 ($INSTANCE_01_NAME)"
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_PAIR_NAME --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID_01 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE_01_NAME"}]" &> /dev/null
echo "Instance 01 launched ($INSTANCE_01_NAME)"

echo "Launching Instance 01 ($INSTANCE_02_NAME)"
aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_PAIR_NAME --security-group-ids $SECURITY_GROUP_ID --subnet-id $SUBNET_ID_02 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value="$INSTANCE_02_NAME"}]" &> /dev/null
echo "Instance 02 launched ($INSTANCE_02_NAME)"