#!/bin/bash

if [[ "$UID" -ne "$ROOT_UID" ]];
then
    echo "You must be root to run this script."
    exit $E_NOTROOT
fi

/bin/bash ./task_01.sh
/bin/bash ./task_04.sh


STUDENT_NAME="Abdullah Mansoor Sufi"
AWS_CLI_VERSION=$(aws --version | awk '{print $1}' | tr "/" "-")
NGINX_VERSION=$(nginx -v 2>&1 | awk -F' ' '{print $3}' | cut -d / -f 2)


if [[ "$?" -eq "0" ]]; then
  NGINX_STATUS="Active"
else
  NGINX_STATUS="Inactive"
fi


EC2_COUNT=$(aws ec2 describe-instances \
                  --filters "Name=instance-type,Values=t2.micro" \
                  --query "Reservations[*].Instances[*].[InstanceId]" \
                  --output text | wc -l)

SG_NONDEFAULT=$(sudo aws ec2 describe-security-groups \
                  --query "SecurityGroups[*].{Name:GroupName}" \
                  --output text | grep -vw "default" | tr '\n' ',' | sed 's/\(.*\),/\1 /')

SG_COUNT=$(aws ec2 describe-security-groups \
              --filters "Name=group-name,Values=$SG_NONDEFAULT" \
              --query "SecurityGroups[*].{Name:GroupName}"  --output text | wc -l)

echo "Creating HTML file for static webpage..."
touch index.html
cat > index.html << EOF

<!DOCTYPE html>
<html>
  <head>
    <title>$STUDENT_NAME</title>
  </head>
  <body style="text-align:center;font-family: Arial;">
    <img src="https://upload.wikimedia.org/wikipedia/en/8/86/SHU_Logo.png" width="300px"/>
    <h1>$STUDENT_NAME</h1>
    <table class="table-center">
      <tr>
        <td>Status of NGINX</td>
        <td>$NGINX_STATUS</td>
      </tr>
      <tr>
        <td>Version of NGINX</td>
        <td>$NGINX_VERSION</td>
      </tr>
      <tr>
        <td>Version of AWS CLI</td>
        <td>$AWS_CLI_VERSION</td>
      </tr>
      <tr>
        <td>Number of EC2 Instances running in my account</td>
        <td>$EC2_COUNT</td>
      </tr>
      <tr>
        <td>Number of Security Groups in my account</td>
        <td>$SG_COUNT</td>
      </tr>
    </table>
  </body>
  <style>
    table, th, td {
      border: 1px solid black;
      border-collapse: collapse;
    }
    
    .table-center {
      margin-left: auto;
      margin-right: auto;
    }
  </style>
</html>

EOF

echo "Deploying static webpage on nginx..."
rm -rf /var/www/html/*
mv index.html /var/www/html
echo "Deployed!"