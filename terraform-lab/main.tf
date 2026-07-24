resource "azurerm_resource_group" "sandbox" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "law-sandbox-monitoring"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}