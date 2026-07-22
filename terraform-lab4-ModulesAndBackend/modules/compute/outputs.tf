output "public_ip" {
  value       = azurerm_public_ip.pip.ip_address
  description = "Public IP address of the VM"
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "ID of the Virtual Machine"
}