output "hub_vnet_id" {
  value       = azurerm_virtual_network.hub_vnet.id
  description = "The Resource ID of the central Hub VNet"
}

output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke_vnet.id
  description = "The Resource ID of the Spoke VNet"
}

output "peering_status" {
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
  description = "The resource identifier for the verification tracking of the peering tunnel"
}