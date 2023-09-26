# Define the Azure provider configuration
provider "azurerm" {
  features {}
}

# Define an Azure resource group
resource "azurerm_resource_group" "example_rg" {
  name     = "example-resource-group"
  location = "East US" # Change to your desired Azure region
}

# Define an Azure virtual network
resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name
}

# Define an Azure subnet within the virtual network
resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Define an Azure Network Security Group (NSG) to allow SSH and any additional rules you need
resource "azurerm_network_security_group" "example_nsg" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Add additional security rules as needed
}

# Define an Azure Network Interface (NIC)
resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.example_rg.location
  resource_group_name = azurerm_resource_group.example_rg.name

  ip_configuration {
    name                          = "example-nic-configuration"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define an Azure Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "example_vm" {
  name                  = "example-vm"
  resource_group_name   = azurerm_resource_group.example_rg.name
  location              = azurerm_resource_group.example_rg.location
  size                  = "Standard_B1s" # Change to your desired VM size
  admin_username        = "adminuser"   # Change to your desired admin username
  admin_ssh_key {
    username            = "adminuser"
    public_key          = file("~/.ssh/id_rsa.pub") # Change to your public key path
  }

  network_interface_ids = [azurerm_network_interface.example_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
