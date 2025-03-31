#!/bin/bash

sudo yum update -y
sudo yum install ansible -y

sudo yum install -y python3-pip  
python3 -m ensurepip --default-pip 
python3 -m pip install --upgrade --user pip  

sudo python3 -m pip install boto3 botocore