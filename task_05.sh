#!/bin/bash

ROOT_UID=0
E_NOTROOT=100

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

/bin/bash ./task_04.sh

echo "Launching Instance 01 (ubuntu-server-01)"

aws ec2 run-instances --image-id ami-08d4ac5b634553e16 --count 1 --instance-type t2.micro --key-name assignment-02-kp --security-group-ids sg-0962d1d8574142036 --subnet-id subnet-0b3ad0e557557ef9d --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="ubuntu-server-01"}]' &> /dev/null
echo "Instance 01 launched (ubuntu-server-01)"

echo "Launching Instance 01 (ubuntu-server-02)"
aws ec2 run-instances --image-id ami-08d4ac5b634553e16 --count 1 --instance-type t2.micro --key-name assignment-02-kp --security-group-ids sg-0962d1d8574142036 --subnet-id subnet-01f4da46cf2805c86 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value="ubuntu-server-02"}]' &> /dev/null
echo "Instance 02 launched (ubuntu-server-02)"