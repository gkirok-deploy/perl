resource "null_resource" "check_connnection" {
  count = "${var.gk_node_count}"
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "60m"
      host        = "${element(aws_instance.gk_server.*.public_ip, count.index)}"
      user        = "centos"
      private_key = "${file(var.gk_private_key_path)}"
    }

    inline = [
      "ls -la"
    ]
  }
}
