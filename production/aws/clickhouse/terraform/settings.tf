variable "region" {
  description = "Amazon Region"
  default = "us-east-1"
}

variable "availability_zone" {
  description = "Amazon Availability Zone"
  default = "us-east-1a"
}

variable "vpc_id" {
  description = "Your VPC ID"
  default = "vpc-54ebfa2e"
}

variable "subnet_id" {
  description = "Your Subnet ID"
  default = "subnet-5eec5250"
}

variable "ami_id" {
  description = "ClickHouse node AMI ID"
  default = "ami-0468cc028a4b6b80b"
}

variable "instance_type" {
  description = "Clickhouse instance type"
  default = "m5ad.12xlarge"
}

variable "root_block_device_volume_size" {
  description = "Size of the root volume in GB"
  default = 1000
}

variable "ssh_port" {
  description = "The SSH port"
  default = 22
}

variable "key_name" {
  description = "Key pair name to get SSH access"
  default = "Jams2"
}

variable "ch_node_multiple_count" {
  description = "Number of nodes to be launched"
  default = 3
}