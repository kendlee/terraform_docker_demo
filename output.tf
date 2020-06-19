output "server_ip" {
  description = "public ip of deployed server"
  value       = aws_instance.server_instance.public_ip
}