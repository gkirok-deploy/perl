resource "aws_security_group" "gk_sg" {
  name        = "${var.gk_rg_name}-sg"
  description = "Allow web access to all and ssh to jenkins"

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.gk_jenkins_ip}"]
  }

  ingress {
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 22 
    protocol    = "tcp"
    cidr_blocks = ["${var.gk_access_ip}"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 8
    protocol    = "icmp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.gk_rg_name}-sg"
    owner = "${var.gk_owner}"
    customer = "${var.gk_customer}"
  }
}

resource "aws_key_pair" "gk_key" {
  key_name   = "${var.gk_rg_name}-key"
  public_key = "${file(var.gk_public_key_path)}"
}
