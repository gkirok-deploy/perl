provider "aws" {
  region = "us-west-2"
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
