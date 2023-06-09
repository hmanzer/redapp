#!/bin/bash
sudo apt-get update
sudo apt-get install nodejs-legacy -y
sudo apt-get install npm  -y
sudo npm install pm2 -g
sudo rm -rf /home/admin/redapp