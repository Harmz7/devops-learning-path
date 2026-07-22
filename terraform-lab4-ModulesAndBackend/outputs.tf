output "vm_public_ip" {
  value       = module.hub_vm.public_ip
  description = "The public IP address of the hub VM"
}