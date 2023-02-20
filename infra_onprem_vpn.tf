resource "azurerm_public_ip" "onprem_vpn_ip" {
  name                = "pip-onprem-vpn"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_onprem.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vgw-onprem" {
  name                = "vgw-onprem"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "Standard"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.onprem_vpn_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet_gateway.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "onprem_to_cloud" {
  name                = "onprem-to-cloud"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_onprem.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw-onprem.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw-cloud.id

  shared_key = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}