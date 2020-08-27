#!/bin/bash

sudo apt-get update
sudo apt -y install apt-transport-https ca-certificates curl git gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update

sudo apt-get install apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4

echo "deb https://repo.clickhouse.tech/deb/stable/ main/" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

echo chef clickhouse-server/default-password posthog | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y clickhouse-server clickhouse-client

sudo service clickhouse-server start

