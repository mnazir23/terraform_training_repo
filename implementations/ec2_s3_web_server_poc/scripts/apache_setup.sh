#!/bin/bash

# First install Apache
sudo apt-get update
sudo apt-get install apache2 -y

# Install AWS CLI
sudo apt-get install awscli -y

# Set up the cron job that will copy index.html from S3
job="* * * * * aws s3 cp s3://${bucket_name}/index.html /var/www/html/"
echo "$job" | crontab -u root -