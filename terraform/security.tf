resource "aws_security_group" "gk_security" {
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

  tags {
    Name = "${var.gk_rg_name}-sg"
    owner = "${var.gk_owner}"
    customer = "${var.gk_customer}"
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.gk_owner}-key"
  public_key = "${file(var.gk_public_key_path)}"
}
