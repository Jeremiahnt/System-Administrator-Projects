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

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "IAC-sga" {
  subnet_id                 = azurerm_subnet.IAC-sn.id
  network_security_group_id = azurerm_network_security_group.IAC-sg.id
}

resource "azurerm_public_ip" "IAC-ip" {
  name = "IAC-ip"
  # Because this is a pretty static test script, if we do a multi-ip and multi-security
  # group environment make the name variables have numbers.
  resource_group_name = azurerm_resource_group.IAC-rg.name
  location            = azurerm_resource_group.IAC-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "IAC-nic" {
  name                = "IAC-nic"
  location            = azurerm_resource_group.IAC-rg.location
  resource_group_name = azurerm_resource_group.IAC-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.IAC-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.IAC-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "azurerm_public_ip" "IAC-ip-data"{
  name = azurerm_public_ip.IAC-ip.name
  resource_group_name = azurerm_resource_group.IAC-rg.name
}

output "passsword" {
  value     = random_password.password.result
  sensitive = true
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.IAC-vm.name}: ${data.azurerm_public_ip.IAC-ip-data.ip_address}"
}

resource "azurerm_linux_virtual_machine" "IAC-vm" {
  name                            = "IAC-vm"
  resource_group_name             = azurerm_resource_group.IAC-rg.name
  location                        = azurerm_resource_group.IAC-rg.location
  size                            = "Standard_B1ls"
  admin_username                  = "User_Here"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.IAC-nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    # architecture: x64
    # offer = 0001-com-ubuntu-server-jammy
    # publisher = Canonical
    # sku = 22_04-lts-gen2
    # urn = Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest
    # urnAlias = Ubuntu2204
    # version = latest
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }
}
