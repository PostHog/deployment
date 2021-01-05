terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

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

resource "aws_ecs_task_definition" "plugins" {
  family                   = "${var.environment}-plugins"
  network_mode             = "awsvpc"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  lifecycle {
    create_before_destroy = true
  }

  container_definitions = file("task-definition.plugins.json") 
}

resource "aws_security_group" "plugins" {
  name   = "${var.environment}-ecs-plugins"
  vpc_id = var.vpc_id

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "plugins" {
  name            = "${var.environment}-plugins"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.plugins.arn
  launch_type     = "FARGATE"

  desired_count                     = 5

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = [aws_security_group.plugins.id]
    assign_public_ip = true
  }
}