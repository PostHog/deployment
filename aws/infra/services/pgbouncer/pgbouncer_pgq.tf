variable "environment" {
  type    = string
  default = "posthog-production"
}

variable "cluster_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnets" {
  type = list(string)
}

variable "cluster_security_group_id" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "pgq-pgbouncer" {
  name               = "${var.environment}-pgq-pgbouncer"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  tags = {
    Service     = "pgq-pgbouncer"
    Environment = var.environment
    Terraform   = "1"
  }
}

resource "aws_lb_target_group" "pgq-pgbouncer" {
  name                 = "${var.environment}-pgq-pgbouncer"
  port                 = 6543
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 180

  health_check {
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }

  tags = {
    Service     = "pgq-pgbouncer"
    Environment = var.environment
    Terraform   = "1"
  }
}

resource "aws_lb_listener" "pgq-pgbouncer" {
  load_balancer_arn = aws_lb.pgq-pgbouncer.id
  port              = 6543
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.pgq-pgbouncer.id
    type             = "forward"
  }
}

resource "aws_ecs_task_definition" "pgq-pgbouncer" {
  family                   = "${var.environment}-pgq-pgbouncer"
  network_mode             = "awsvpc"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  lifecycle {
    create_before_destroy = true
  }

  container_definitions = <<EOF
[
  {
    "name": "pgbouncer",
    "image": "edoburu/pgbouncer:1.12.0",
    "portMappings": [{
      "hostPort": 6543,
      "containerPort": 6543,
      "protocol": "tcp"
    }],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.environment}-pgbouncer",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs-pgbouncer"
        }
    },
    "secrets": [
        {
            "name": "DATABASE_URL",
            "valueFrom": "arn:aws:secretsmanager:us-east-1:795637471508:secret:Posthog_Production_Heroku-FQ2itU:JOB_QUEUE_GRAPHILE_URL::"
        }
    ],
    "environment": [
        {
            "name": "LISTEN_PORT",
            "value": "6543"
        },
        {
            "name": "MAX_CLIENT_CONN",
            "value": "1000"
        },
        {
            "name": "POOL_MODE",
            "value": "transaction"
        },
        {
            "name": "SERVER_TLS_SSLMODE",
            "value": "require"
        }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 16384,
        "hardLimit": 16384
      }
    ],
    "essential": true
  }
]
EOF
}

resource "aws_security_group" "pgq-pgbouncer" {
  name   = "${var.environment}-ecs-pgq-pgbouncer"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 6543
    to_port     = 6543
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "pgq-pgbouncer" {
  name            = "${var.environment}-pgq-pgbouncer"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.pgq-pgbouncer.arn
  launch_type     = "FARGATE"

  desired_count                     = 3
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = [aws_security_group.pgq-pgbouncer.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.pgq-pgbouncer.id
    container_name   = "pgbouncer"
    container_port   = 6543
  }
}