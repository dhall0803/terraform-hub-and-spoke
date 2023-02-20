# Create VMs for testing

resource "azurerm_network_interface" "vm-001" {
  name                = "nic-vm-workload1"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-workload1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "workload1" {
  name                = "vm-workload-001"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = local.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm-001.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "vm-002" {
  name                = "nic-vm-workload2"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-workload2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "workload2" {
  name                = "vm-workload-002"
  resource_group_name = azurerm_resource_group.rg_network.name
  location            = local.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm-002.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}