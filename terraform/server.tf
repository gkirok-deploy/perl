resource "aws_instance" "gk_server" {
  ami = "${var.ami_id}"
  count = "${var.gk_node_count}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.gk_sg.id}"]
  key_name = "${var.gk_rg_name}-key"

  tags {
    Name = "${var.gk_rg_name}-kube-${count.index}"
    owner = "${var.gk_owner}"
    customer = "${var.gk_customer}"
  }
}
