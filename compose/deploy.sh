#!/bin/bash
set -e

# Talk to the user
echo "Welcome to the single instance PostHog installer 🦔"
echo "Let's first start by getting the exact domain PostHog will be installed on"
echo "ie: test.posthog.net"
read DOMAIN
export DOMAIN=$DOMAIN
echo "Ok we'll set up certs for https://$DOMAIN"
echo "Do you have a Sentry DSN you would like for debugging should something go wrong?"
echo "If you do enter it now, otherwise just hit enter to continue"
read SENTRY_DSN
export SENTRY_DSN=$SENTRY_DSN
echo "Ok! We'll take it from here 🚀"

# update apt cache
echo "Grabbing latest apt caches"
apt update

# clone posthog
echo "Installing PostHog 🦔 from Github"
apt install -y git
rm -rf posthog
git clone https://github.com/PostHog/posthog.git 

# rewrite caddyfile
rm -f Caddyfile
envsubst > Caddyfile <<EOF
$DOMAIN, :80, :443 {
reverse_proxy http://web:8000
}
EOF

# setup docker
echo "Setting up Docker"
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt update
apt-cache policy docker-ce
apt install -y docker-ce


# setup docker-compose
echo "Setting up Docker Compose"
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# start up the stack (remember to have --build here for upgrades)
rm -f docker-compose.yml
curl -o ./docker-compose.yml https://raw.githubusercontent.com/posthog/deployment/HEAD/compose/docker-compose.yml
docker-compose -f docker-compose.yml up
