output "public_ip" {
  value       = azurerm_public_ip.web_pip.ip_address
  description = "The public IP address of the Web VM"
}