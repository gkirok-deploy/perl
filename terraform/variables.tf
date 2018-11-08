variable "aws_region" {
  default = "us-west-2"
}

provider "aws" {
  region = "${var.aws_region}"
}


variable "ami_id" {
  default = "ami-3ecc8f46"
}

variable "gk_rg_name" {
  default = "gk"
}

variable "gk_owner" {
  default = "gkirok"
}

variable "gk_customer" {
  default = "gk-customer"
}

variable "gk_node_count" {
  default = "3"
}

variable "gk_access_ip" {}

variable "gk_jenkins_ip" {}

variable "gk_public_key_path" {
  default="~/.ssh/tikal.pub"
}

variable "gk_private_key_path" {
  default="~/.ssh/tikal"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}
