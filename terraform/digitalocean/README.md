# PostHog on DigitalOcean

## Multi-Node Install

This installation gets you started up with a scalable end to end infrastructure for Posthog. Everything in this is tuneable, but for safety reasons the node sizes are all set to the smallest possible to start out with

### Cost

- 2 x 1GB/1CPU Droplet @ \$5
- 1 x 1GB/1CPU Postgres @ \$15
- 1 x 0.7GB/1CPU Redis @ \$15
- Total Cost per Month ≈ \$40

## Single-Node install

This is a basic setup for trialing Posthog. It won't scale much but it definitely will get you a feel for what the product can do. This is also the image we use for our partner integration with DigitalOcean

### Cost

- 1 x 1GB/1CPU Droplet @ \$5
- Total Cost per Month ≈ \$5

## Quickstart

DigitalOcean has a great [tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean) on how to get started with Terraform on their platform. We borrow heavily from their excellent documents here

### Step 1 — Configuring your Environment

Terraform will use your DigitalOcean Personal Access Token to communicate with the DigitalOcean API and manage resources in your account. Don’t share this key with others, and keep it out of scripts and version control. Export your DigitalOcean Personal Access Token to an environment variable called DO_PAT. This will make using it in subsequent commands easier and keep it separate from your code:

```bash
export DO_PAT={YOUR_PERSONAL_ACCESS_TOKEN}
```

Next, you’ll need the MD5 fingerprint of the public key you’ve associated with your account, so Terraform can add it to each machine it provisions. Assuming that your private key is located at ~/.ssh/id_rsa, use the following command to get the MD5 fingerprint of your public key:

```bash
ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'
```

This will output something like the following:

Output
md5:e7:42:16:d7:...9e:92:f7
You will provide this fingerprint, minus the md5: prefix, when running Terraform. To make this easier, export your SSH fingerprint to your environment as well:

```bash
export DO_SSH_FINGERPRINT=":42:16:d7:e5:a0:43:29:82:7d:a0:59:cf:9e:92:f7"
```

Now that you have your environment variables configured, let’s install PostHog.

### Step 2 - Setup the Infrastructure

- `cd` into the directory that represents the infrastructure you would like to setup, single-node or multi-node

Run the `apply.sh` bash script for applying the configs to your DigitalOcean environment.

_Before doing this it is suggested that you check out the configs and make sure the instance sizes for the droplets and databases suite your needs_

```bash
./apply.sh
```

#### Special instructiones for multi-node install with load balancer

The configuration for multi-node PostHog includes a load balancer configured with a certificate issued by LetsEncrypt. In order for that certificate to work when you first run the apply script it will ask you for the `FQDN` fully qualified domain name that PostHog will be running at. So if PostHog will be running at `ph.posthog.com` make sure that is what you enter here.

### Optional Final Step - Destroy Infrastructure

Included is a script that will instruct Terriform to destroy the infrastructure we created earlier. To do this all you need to do is run the following.

```bash
./destroy.sh
```
