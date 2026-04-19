data "azurerm_resource_group" "existing_rg" {
  name = "terraformrg"
}
data "azurerm_virtual_network" "existing_vnet" {
  name = "tf_vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}
data "azurerm_subnet" "existing_block" {
  name = "subent3"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name

}

resource "azurerm_subnet" "subnet_block1" {
  name = "subent4"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  address_prefixes = [("10.0.4.0/24")]

}


data "azurerm_network_interface" "nic_block" {
  name                = "ubuntu01-nic"
   resource_group_name = data.azurerm_resource_group.existing_rg.name

  }

resource "azurerm_linux_virtual_machine" "vm_block" {
  name                = "ubuntu01"
  resource_group_name = "terraformrg"
  location            = "westus"
  size                = "Standard_D2s_v3"

  admin_username = "adminuser"
  admin_password = "Password@123"
  disable_password_authentication = false

  network_interface_ids = [
    data.azurerm_network_interface.nic_block.id
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