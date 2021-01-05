cluster_id                = "posthog-production-cluster"
cluster_security_group_id = "sg-05a5f7e510b15473c"
subnets = [
  "subnet-34910579",
  "subnet-8738fde1",
  "subnet-65333b5b",
  "subnet-9bae6fc4",
  "subnet-f6dc1fd7",
  "subnet-5eec5250"
]
vpc_id = "vpc-54ebfa2e"
vpc_subnets = [
  "subnet-34910579",
  "subnet-8738fde1",
  "subnet-65333b5b",
  "subnet-9bae6fc4",
  "subnet-f6dc1fd7",
  "subnet-5eec5250"
]

// enter arn for posthog-production-ecs-task here
ecs_task_role_arn = "<arn prefix>/posthog-production-ecs-task"