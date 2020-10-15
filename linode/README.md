# PostHog on Linode

At the moment we only support single-node installations on Linode.

## Single-Node install

1. Linode has an [official tutorial](https://www.linode.com/docs/platform/stackscripts/how-to-deploy-a-new-linode-using-a-stackscript/) on deploying a Linode using a StackScript. We recommend you follow along there.

2. Use an `Account StackScript` and paste in [StackScript.sh](https://github.com/PostHog/deployment/blob/master/linode/StackScript.sh) as the `Script`. 

- This PostHog deployment is compatible with any version of Ubuntu or Debian, but we recommend using `Ubuntu 20.04 LTS` if you can't choose.

- Your Linode should start up and you should be able to visit the PostHog instance by navigating to the `IPv4` address under `Networking` or any revese DNS solution you might be using.

