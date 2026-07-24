variable "location" {
  type        = string
  default     = "East US 2"
  description = "Azure region for all resources"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-devops-lab3"
  description = "Name of the resource group"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Admin username for virtual machines"
}

variable "admin_password" {
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
  description = "Admin password for virtual machines"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1ms"
  description = "Size of the virtual machines"
}