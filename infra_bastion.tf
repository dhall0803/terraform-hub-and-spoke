resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bastion"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "abh-hubanspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.snet-bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }
}