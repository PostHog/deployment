#!/bin/bash
set -e

# Seed a secret
export POSTHOG_SECRET=`echo $RANDOM | md5sum | head -c 25`

# Talk to the user
echo "Welcome to the single instance PostHog installer 🦔"
echo "\n"
echo "⚠️ You really need 4gb or more of memory to run this stack ⚠️"
echo "\n"
echo "Let's first start by getting the exact domain PostHog will be installed on"
echo "Make sure that you have a Host A DNS record pointing to this instance!"
echo "This will be used for TLS 🔐"
echo "ie: test.posthog.net"
read DOMAIN
export DOMAIN=$DOMAIN
echo "Ok we'll set up certs for https://$DOMAIN"
echo "\n"
echo "Do you have a Sentry DSN you would like for debugging should something go wrong?"
echo "If you do enter it now, otherwise just hit enter to continue"
read SENTRY_DSN
export SENTRY_DSN=$SENTRY_DSN
echo "\n"
echo "We will need sudo access so the next question is for you to give us superuser access"
echo "Please enter your sudo password now:"
sudo echo ""
echo "Thanks! 🙏"
echo "\n"
echo "Ok! We'll take it from here 🚀"

# update apt cache
echo "Grabbing latest apt caches"
sudo apt update

# clone posthog
echo "Installing PostHog 🦔 from Github"
sudo apt install -y git
rm -rf posthog
git clone https://github.com/PostHog/posthog.git 

# rewrite caddyfile
rm -f Caddyfile
envsubst > Caddyfile <<EOF
$DOMAIN, :80, :443 {
reverse_proxy http://web:8000
}
EOF

# write entrypoint
rm -rf compose
mkdir -p compose
cat > compose/start <<EOF
#!/bin/bash
python manage.py migrate
python manage.py migrate_clickhouse
./bin/docker-server
./bin/docker-frontend
EOF
chmod +x compose/start

# setup docker
echo "Setting up Docker"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo -E apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt-cache policy docker-ce
sudo apt install -y docker-ce


# setup docker-compose
echo "Setting up Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || true
sudo chmod +x /usr/local/bin/docker-compose

# enable docker without sudo
sudo usermod -aG docker ${USER}

# start up the stack (remember to have --build here for upgrades)
rm -f docker-compose.yml
curl -o docker-compose.yml https://raw.githubusercontent.com/posthog/deployment/HEAD/compose/docker-compose.yml
docker-compose -f docker-compose.yml stop | true
docker-compose -f docker-compose.yml up --build -d

echo "🎉🎉🎉 Done! 🎉🎉🎉"
echo "You will need to wait ~5-10 minutes for things to settle down, migrations to finish, and TLS certs to be issued"
echo "\n"
echo "To stop the stack run `docker-compose stop`"
echo "To start the stack again run `docker-compose start`"
echo "If you have any issues at all delete everything in this directory and run the curl command again"
echo "\n"

echo "PostHog will be up at the location you provided!"
echo "https://${DOMAIN}"
echo "\n\n"
echo "**It's dangerous to go alone! Take this. 🦔**"