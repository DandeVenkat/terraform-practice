data "azurerm_resource_group" "existing_rg" {
  name = "terraformrg"
}
data "azurerm_virtual_network" "existing_vnet" {
  name = "tf_vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
resource "azurerm_subnet" "subnet_block" {
  name = "subent3"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes = [("10.0.3.0/24")]

}


resource "azurerm_network_interface" "nic_block" {
  name                = "ubuntu01-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_block.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_block" {
  name                = "ubuntu01"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  location            = data.azurerm_resource_group.existing_rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "Password@3214"
  disable_password_authentication = false
 
  network_interface_ids = [
    azurerm_network_interface.nic_block.id,
  ]

  

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