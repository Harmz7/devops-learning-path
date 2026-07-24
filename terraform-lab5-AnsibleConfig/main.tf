# Resource Group
resource "azurerm_resource_group" "lab5_rg" {
  name     = "rg-devops-lab5"
  location = "eastus2"
}

# Network Module (Reusing Lab 4 module!)
module "lab5_network" {
  source = "../terraform-lab4-ModulesAndBackend/modules/network"

  resource_group_name   = azurerm_resource_group.lab5_rg.name
  location              = azurerm_resource_group.lab5_rg.location
  vnet_name             = "vnet-lab5"
  address_space         = ["10.5.0.0/16"]
  subnet_name           = "Subnet-Web"
  subnet_address_prefix = ["10.5.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "web_pip" {
  name                = "pip-lab5-web"
  resource_group_name = azurerm_resource_group.lab5_rg.name
  location            = azurerm_resource_group.lab5_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Security Group (NSG) to allow SSH (22) and HTTP (80)
resource "azurerm_network_security_group" "web_nsg" {
  name                = "nsg-lab5-web"
  location            = azurerm_resource_group.lab5_rg.location
  resource_group_name = azurerm_resource_group.lab5_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NIC
resource "azurerm_network_interface" "web_nic" {
  name                = "nic-lab5-web"
  location            = azurerm_resource_group.lab5_rg.location
  resource_group_name = azurerm_resource_group.lab5_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.lab5_network.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }
}

# Associate NSG to NIC
resource "azurerm_network_interface_security_group_association" "web_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.web_nic.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Linux VM configured with SSH Key
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                            = "vm-lab5-web"
  resource_group_name             = azurerm_resource_group.lab5_rg.name
  location                        = azurerm_resource_group.lab5_rg.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.web_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_public_key_path)
  }

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