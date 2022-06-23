#!/bin/bash

ROOT_UID=0
E_NOTROOT=100

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

/bin/bash ./task_03.sh

cat ~/.aws/credentials &> /dev/null && {
    echo "aws-cli is already configured on your machine."
}

cat ~/.aws/credentials &> /dev/null || {
    echo "Configuring aws-cli on your machine..."
    
    DEFAULT_REGION="us-east-1"
    DEFAULT_OUTPUT="json"
    AWS_ACCESS_KEY_ID="$(aws ssm get-parameter --name  ACCESS_KEY_ID --query "Parameter.Value" --output text)"
    AWS_SECRET_ACCESS_KEY="$(aws ssm get-parameter --name  SECRET_ACCESS_KEY --query "Parameter.Value" --output text)"
    
    aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
    aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
    aws configure set default.region $DEFAULT_REGION
    aws configure set default.output $DEFAULT_OUTPUT
    
    echo "aws-cli configured!"   
}