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
  default = "172.31.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.1.0.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for the private subnet a"
  default = "172.31.0.0/20"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the private subnet b"
  default = "172.31.16.0/20"
}

variable "private_subnet_c_cidr" {
  description = "CIDR for the private subnet c"
  default = "172.31.32.0/20"
}
