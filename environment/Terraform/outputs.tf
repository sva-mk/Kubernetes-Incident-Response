output "private_key" {
  value       = tls_private_key.ssh_key.private_key_openssh
  description = "The ssh-private key used to connect to every node"
  sensitive   = true
}

output "public_key" {
  value       = tls_private_key.ssh_key.public_key_openssh
  description = "The ssh-public key used to connect to every node"
  sensitive   = true
}
