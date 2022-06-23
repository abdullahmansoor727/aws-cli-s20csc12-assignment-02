#!/bin/bash

ROOT_UID=0
E_NOTROOT=100
E_NO_NGINX=122
GREEN="\e[1;32m"
RED="\e[1;31m"
CE="\e[m"

if [ "$UID" -ne "$ROOT_UID" ]
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

which nginx &> /dev/null || {
    echo -e "$RED Please install nginx first...$CE"
    exit $E_NO_NGINX
}

systemctl status nginx &> /dev/null
if [[ "$?" -eq "0" ]]
then
    echo -e "$GREEN"" NGINX is Running $CE"
    exit 0
else
    echo -e "$RED""NGINX is Dead. Do you want to run NGINX [y/n]? $CE"
    read -rp "" INSTALL
    if [[ $INSTALL =~ ^([yY])$ ]]; then
        systemctl start nginx
    fi
fi
