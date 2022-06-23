#!/bin/bash

ROOT_UID=0
E_NOTROOT=100

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

which nginx &> /dev/null || {
  echo "Installing nginx..."
  apt install update -y &> /dev/null
  apt install upgrade -y &> /dev/null
  apt install nginx -y &> /dev/null
  echo "Installed NGINX!"
} && {
  echo "Updating nginx..."
  apt install update -y &> /dev/null
  apt install upgrade -y &> /dev/null
  apt install nginx --upgrade -y &> /dev/null
  echo "Completed."
}
