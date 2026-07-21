# 1. Base Resource Group
resource "azurerm_resource_group" "lab3_rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2. Hub VNet & Subnet
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lab3_rg.location
  resource_group_name = azurerm_resource_group.lab3_rg.name
}

resource "azurerm_subnet" "hub_subnet" {
  name                 = "Subnet-Management"
  resource_group_name  = azurerm_resource_group.lab3_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. Spoke VNet & Subnet
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "vnet-spoke"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.lab3_rg.location
  resource_group_name = azurerm_resource_group.lab3_rg.name
}

resource "azurerm_subnet" "spoke_subnet" {
  name                 = "Subnet-Workloads"
  resource_group_name  = azurerm_resource_group.lab3_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

# 4. Bi-directional VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-spoke"
  resource_group_name          = azurerm_resource_group.lab3_rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id   = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-spoke-to-hub"
  resource_group_name          = azurerm_resource_group.lab3_rg.name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id   = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
}

# 5. Public IP for Hub VM (Bastion/Management Jump Host)
resource "azurerm_public_ip" "hub_pip" {
  name                = "pip-hub-vm"
  location            = azurerm_resource_group.lab3_rg.location
  resource_group_name = azurerm_resource_group.lab3_rg.name
  allocation_method   = "Static"
  sku = "Standard"
}

# 6. Network Interfaces (NICs)
resource "azurerm_network_interface" "hub_nic" {
  name                = "nic-hub-vm"
  location            = azurerm_resource_group.lab3_rg.location
  resource_group_name = azurerm_resource_group.lab3_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hub_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hub_pip.id
  }
}

resource "azurerm_network_interface" "spoke_nic" {
  name                = "nic-spoke-vm"
  location            = azurerm_resource_group.lab3_rg.location
  resource_group_name = azurerm_resource_group.lab3_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.spoke_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# 7. Linux VMs (Ubuntu 22.04 LTS)
resource "azurerm_linux_virtual_machine" "hub_vm" {
  name                = "vm-hub"
  resource_group_name = azurerm_resource_group.lab3_rg.name
  location            = azurerm_resource_group.lab3_rg.location
  size                = "var.vm_size"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.hub_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "spoke_vm" {
  name                = "vm-spoke"
  resource_group_name = azurerm_resource_group.lab3_rg.name
  location            = azurerm_resource_group.lab3_rg.location
  size                = "var.vm_size"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.spoke_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}