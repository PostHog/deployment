# PostHog deployment options

## If you want a quick install on an Ubuntu VM

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/posthog/deployment/HEAD/compose/deploy.sh)"
```


You can find a full list of guides at https://posthog.com/docs/deployment

## Deployments configured in this repo:

### Docker Compose

Via [Docker Compose](https://docs.docker.com/compose/)
Check out `/compose` directory
### Kubernetes

https://posthog.com/docs/deployment/deploy-kubernetes

Via [Helm Chart](https://github.com/PostHog/charts)

### Terraform on Digital Ocean

https://posthog.com/docs/deployment/deploy-digital-ocean

- DigitalOcean - Single node install
- DigitalOcean - Distributed with Redis, Posgres, Load Balancer, LetsEncrypt, SSL/TLS only

## Contributing

If you have a favorite config that you use we would to love include it here! We are always looking for fresh pull requests.

## Questions?

### [Join our Slack community.](https://posthog.com/slack)
