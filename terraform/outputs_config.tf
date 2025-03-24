output "admin_host_public_ip" {
  description = "Public IP of the admin (bastion) host"
  value       = aws_instance.admin_host.public_ip
}

output "internal_ec2_private_ips" {
  description = "Private IPs of the internal (private) EC2 instances"
  value       = aws_instance.internal_hosts[*].private_ip
}
