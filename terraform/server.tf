resource "aws_instance" "gk_server" {
  ami           = "${var.ami_id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.gk_security.id}"]

  tags {
    Name = "${var.gk_rg_name}-server"
    owner = "${var.gk_owner}"
    customer = "${var.gk_customer}"
  }
}
