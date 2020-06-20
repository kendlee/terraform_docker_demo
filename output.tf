output "server_ip" {
  description = "public ip of deployed server"
  value       = aws_instance.server_instance.public_ip
}

output "server_name" {
  description = "public ip of deployed server"
  value       = aws_instance.server_instance.public_dns
}

output "complete_url" {
  description = "complete url to access the deployed container"
  value       = "${aws_instance.server_instance.public_dns}:${var.server_port}"
}