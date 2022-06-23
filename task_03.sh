#!/bin/bash

ROOT_UID=0
E_NOTROOT=100

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

CURR_ARCH=$(uname -m)

if [[ $CURR_ARCH == "x86_64" ]]
then
    ARCH="x86_64"
else
    ARCH="aarch64"
fi

which aws &> /dev/null && {
    echo "$(aws --version | awk '{print $1}' | tr "/" "-") is already installed in your machine"
}

which aws &> /dev/null || {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "awscliv2.zip" &> /dev/null
    which unzip &> /dev/null || {
        echo "Installing dependencies (unzip)..."
        apt install unzip -y &> /dev/null
    } && echo "Unzip is installed"
    echo "Extracting zip and installing aws-cli..."
    unzip awscliv2.zip &> /dev/null
    ./aws/install &> /dev/null
    echo "aws-cli installed."
}