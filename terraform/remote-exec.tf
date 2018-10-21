resource "null_resource" "check_connnection" {
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "60m"
      host        = "${aws_instance.gk_server.*.public_ip}"
      user        = "centos"
      private_key = "${file(var.gk_private_key_path)}"
    }

    inline = [
      "ls -la"
    ]
  }
}
