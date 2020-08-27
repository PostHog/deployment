terraform {
  required_version = ">= 0.8, <= 0.12"
}

provider "aws" {
  region = "${var.region}"
}
