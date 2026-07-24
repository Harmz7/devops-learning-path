variable "location" {
  type        = string
  default     = "eastus"
  description = "Primary location for the network hub and spoke"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-enterprise-networking"
  description = "The container for our network infrastructure"
}
variable "hub_vnet_name" {
  type        = string
  default     = "vnet-prod-hub-01"
  description = "Name of the central hub network"
}

variable "hub_address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space allocated for the hub network"
}

variable "spoke_vnet_name" {
  type        = string
  default     = "vnet-prod-spoke-01"
  description = "Name of the workload spoke network"
}

variable "spoke_address_space" {
  type        = list(string)
  default     = ["10.1.0.0/16"]
  description = "Address space allocated for the spoke network"
}