variable "resource_group_name" {
  type        = string
  default     = "rg-devops-sandbox"
  description = "The name of our training resource group"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "The Azure region for our resources"
}