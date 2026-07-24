# 1. Base Resource Group
resource "azurerm_resource_group" "lab4_rg" {
  name     = "rg-devops-lab4"
  location = "eastus2"
}

# 2. Call the Network Module for Hub VNet
module "hub_network" {
  source = "./modules/network"

  resource_group_name   = azurerm_resource_group.lab4_rg.name
  location              = azurerm_resource_group.lab4_rg.location
  vnet_name             = "vnet-hub"
  address_space         = ["10.0.0.0/16"]
  subnet_name           = "Subnet-Management"
  subnet_address_prefix = ["10.0.1.0/24"]
}

# 3. Call Compute Module (Consumes subnet_id from hub_network module!)
module "hub_vm" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.lab4_rg.name
  location            = azurerm_resource_group.lab4_rg.location
  subnet_id           = module.hub_network.subnet_id
  vm_name             = "vm-hub"
  admin_password      = var.admin_password
}