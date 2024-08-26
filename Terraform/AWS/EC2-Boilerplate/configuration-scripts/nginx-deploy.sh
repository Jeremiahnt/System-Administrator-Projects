#!/bin/bash

AWS_ACCESS_KEY_ID="ENTER_HERE"
AWS_SECRET_ACCESS_KEY="ENTER_HERE"
AWS_DEFAULT_REGION="us-east-1"
AWS_DEFAULT_OUTPUT="json"

export DEBIAN_FRONTEND=noninteractive

sudo apt -y remove needrestart
sudo apt update -y && sudo apt upgrade -y -o Dpkg::Options::="--force-confnew"
sudo apt install -y nginx
sudo apt install -y unzip 
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION
aws configure set default.output $AWS_DEFAULT_OUTPUT

echo "Launch was successful" > /tmp/hello.txt

aws s3 cp /tmp/hello.txt s3://chungus-test

unset DEBIAN_FRONTEND
