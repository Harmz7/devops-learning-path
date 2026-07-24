# 1. Base Resource Group
resource "azurerm_resource_group" "net_rg" {
  name     = var.resource_group_name
  location = var.location
}

#2 Hub Virtual Network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  address_space       = var.hub_address_space

  subnet {
    name           = "Subnet-SharedServices"
    address_prefix = "10.0.1.0/24"
  }
}

#3 Spoke Virtual Network
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = var.spoke_vnet_name
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  address_space       = var.spoke_address_space

  subnet {
    name           = "Subnet-WebApps"
    address_prefix = "10.1.1.0/24"
  }
}

# 4. Peering: Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.net_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
}

# 5. Peering: Spoke to Hub (Required for bi-directional traffic)
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.net_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
}