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
  default = "vpc-98172de1"
}

variable "subnet_id" {
  description = "Your Subnet ID"
  default = "subnet-52b6ef08"
}

variable "ami_id" {
  description = "ClickHouse node AMI ID"
  default = "ami-fd433e82"
}

variable "instance_type" {
  description = "Your instance type"
  default = "t2.medium"
}

variable "root_block_device_volume_size" {
  description = "Size of the root volume in GB"
  default = 20
}

variable "ssh_port" {
  description = "The SSH port"
  default = 22
}

variable "key_name" {
  description = "Key pair name to get SSH access"
  default = "ubuntu_key_pair"
}

variable "ch_node_multiple_count" {
  description = "Number of nodes to be launched"
  default = 3
}