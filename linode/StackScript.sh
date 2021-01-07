#!/bin/bash

# run updates
apt-get -o Acquire::ForceIPv4=true update -y
DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install grub-pc
apt-get -o Acquire::ForceIPv4=true update -y

# install dependencies
apt -y install apt-transport-https ca-certificates curl git gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

# set up docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# download and deploy PostHog
git clone https://github.com/PostHog/deployment.git
cd deployment/terraform/digitalocean/single_node
cat docker-compose.do.yml | sed 's/DigitalOcean/Linode/g' > docker-compose.linode.yml
docker-compose -f docker-compose.linode.yml up -d
