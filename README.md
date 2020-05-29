# PostHog deployment scripts

Dumping ground for different deployment configs.

## Deployments that we currently support:

- AWS CloudFormation
  - Using ECS, Fargate, Postgres RDS, and Elasticache Redis
- Kubernetes via [Helm Chart](https://github.com/PostHog/charts)
- Terraform
  - DigitalOcean - Single node install
  - DigitalOcean - Distributed with Redis, Posgres, Load Balancer, LetsEncrypt, SSL/TLS only

## Deployments we would love to support:

- Ansible
- Chef

## Contributing

If you have a favorite config that you use we would to love include it here! We are always looking for fresh pull requests.
