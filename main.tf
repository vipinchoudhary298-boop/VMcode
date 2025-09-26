resource "azurerm_resource_group" "rg01" {
  name     = "dev-rg-001"
  location = "Westus"
}

resource "azurerm_virtual_network" "Vnet" {
  depends_on          = [azurerm_resource_group.rg01]
  name                = "dev-vent-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "dev-subnet-001"
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "dev-nic-001"
  location            = azurerm_resource_group.rg01.location
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/790084ef-9e9f-4ebf-9120-98c5295aba2a/resourceGroups/dev-rg-001/providers/Microsoft.Network/virtualNetworks/dev-vent-001/subnets/dev-subnet-001"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "dev-vm-001"
  resource_group_name             = azurerm_resource_group.rg01.name
  location                        = azurerm_resource_group.rg01.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = "Kuchbhi@12345"
  disable_password_authentication = false
  network_interface_ids           = ["/subscriptions/790084ef-9e9f-4ebf-9120-98c5295aba2a/resourceGroups/dev-rg-001/providers/Microsoft.Network/networkInterfaces/dev-nic-001"]


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
