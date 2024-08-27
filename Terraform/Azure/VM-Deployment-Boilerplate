terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "IAC-rg" {
  name     = "Hello-World"
  location = "westus"
  tags = {
    environment = "Hello-World"
  }
}

resource "azurerm_virtual_network" "IAC-vn" {
  name                = "Hello-World"
  resource_group_name = azurerm_resource_group.IAC-rg.name
  location            = azurerm_resource_group.IAC-rg.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "Hello-World"
  }
}

resource "azurerm_subnet" "IAC-sn" {
  name                 = "IAC-sn-subnet"
  resource_group_name  = azurerm_resource_group.IAC-rg.name
  virtual_network_name = azurerm_virtual_network.IAC-vn.name
  address_prefixes     = ["10.0.0.0/24"]

}

resource "azurerm_network_security_group" "IAC-sg" {
  name                = "IAC-sg"
  location            = azurerm_resource_group.IAC-rg.location
  resource_group_name = azurerm_resource_group.IAC-rg.name

  security_rule {
    name                       = "IAC-dev-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  #Yes, EVERY port is OPEN 🗿

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "IAC-sg" {
  subnet_id                 = azurerm_subnet.IAC-sn.id
  network_security_group_id = azurerm_network_security_group.IAC-sg.id
}

resource "azurerm_public_ip" "IAC-ip" {
  count = 6
  name = "IAC-ip-${count.index}"
  resource_group_name = azurerm_resource_group.IAC-rg.name
  location            = azurerm_resource_group.IAC-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "IAC-nic" {
  count               = 6
  name                = "IAC-nic${count.index}"
  location            = azurerm_resource_group.IAC-rg.location
  resource_group_name = azurerm_resource_group.IAC-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.IAC-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.IAC-ip[count.index].id
  }

  tags = {
    environment = "dev"
  }
}

variable "username" {
  type    = string
  default = "Amigo2503"
}
variable "password" {
  type    = string
  default = "P@$$w0RD23lp"
}

resource "azurerm_virtual_machine" "AZ-DC-Master" {               
  name                            = "AZ-DC-Master"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  vm_size                         = "Standard_B1ms"
  network_interface_ids           = [azurerm_network_interface.IAC-nic[0].id]

  delete_os_disk_on_termination   = true

  storage_os_disk {
    name                 = "AZ-DC-Master"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type    = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_profile{
    computer_name                         = "AZ-DC-Master"
    admin_username                        = var.username
    admin_password                        = var.password
  }
  os_profile_windows_config{
    provision_vm_agent = false
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_machine" "AZ-DC" {
  count                           = 2
  name                            = "AZ-DC-${count.index}"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  vm_size                         = "Standard_B1ms"
  network_interface_ids           = [azurerm_network_interface.IAC-nic[count.index + 1].id]

  delete_os_disk_on_termination   = true

  storage_os_disk {
    name                 = "AZ-DC-${count.index}"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_profile{
    computer_name                         = "AZ-DC${count.index}"
    admin_username                        = var.username
    admin_password                        = var.password
  }
  os_profile_windows_config{
    provision_vm_agent = false
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_machine" "AAD-DC" {
  count = 1
  name                            = "AAD-DC"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  vm_size                         = "Standard_B1ms"
  network_interface_ids           = [azurerm_network_interface.IAC-nic[count.index + 3].id]
  #The three AD DC's will get the first 3 network interfaces created earlier..

  delete_os_disk_on_termination   = true

  storage_os_disk {
    name                 = "AAD-DC"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  os_profile{
    computer_name                         = "AAD-DC"
    admin_username                        = var.username
    admin_password                        = var.password
  }
  os_profile_windows_config{
    provision_vm_agent = false
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_machine" "Windows-10-Desktop" {
  count = 1
  name                            = "Windows-10-Desktop"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  vm_size                         = "Standard_B1ms"
  network_interface_ids           = [azurerm_network_interface.IAC-nic[count.index + 4].id]

  delete_os_disk_on_termination   = true

  storage_os_disk {
    name                 = "Windows-10-Desktop"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "19h1-pro-gensecond"
    version   = "18362.1256.2012032308"
  }

  os_profile{
    computer_name                         = "Windows-10-Desktop"
    admin_username                        = var.username
    admin_password                        = var.password
  }
  os_profile_windows_config{
    provision_vm_agent = false
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_machine" "Windows-11-Desktop" {
  count = 1
  name                            = "Windows-11-Desktop"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  vm_size                         = "Standard_B1ms"
  network_interface_ids           = [azurerm_network_interface.IAC-nic[count.index + 5].id]

  delete_os_disk_on_termination   = true

  storage_os_disk {
    name                 = "Windows-11-Desktop"
    caching              = "ReadWrite"
    create_option        = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-21h2-pro"
    version   = "22000.2538.231001"
  }

  os_profile{
    computer_name                         = "Windows-11-Desktop"
    admin_username                        = var.username
    admin_password                        = var.password
  }
  os_profile_windows_config{
    provision_vm_agent = false
  }

  tags = {
    environment = "dev"
  }
}
