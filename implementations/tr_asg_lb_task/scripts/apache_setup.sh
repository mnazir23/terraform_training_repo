#!/bin/bash

# First install Apache
sudo apt-get update
sudo apt-get install apache2 -y

# Download the Sample Website
wget https://www.free-css.com/assets/files/free-css-templates/download/page252/live-dinner.zip
sudo apt-get install unzip -y
sudo unzip live-dinner.zip -d /var/www/html/
sudo rm -f /var/www/html/index.html