output "gk_server_public_ips" {
  value = ["${aws_instance.gk_server.*.public_ip}"]
}

output "gk_server_private_ips" {
  value = ["${aws_instance.gk_server.*.private_ip}"]
}
