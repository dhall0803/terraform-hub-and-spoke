# Create spoke 1 network

resource "azurerm_virtual_network" "vnet_spoke_1" {
  name                = "vnet-spoke-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.20.1.0/24"]
}

# Create workload subnet

resource "azurerm_subnet" "snet-workload1" {
  name                 = "snet-workload-dev-uksouth-001"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_1.name
  address_prefixes     = ["10.20.1.0/24"]
}

# Peer spoke 1 to hub

resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                      = "Spoke1ToHub"
  resource_group_name       = azurerm_resource_group.rg_network.name
  virtual_network_name      = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_spoke_1.id
  allow_forwarded_traffic   = true
  allow_gateway_transit = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                      = "HubToSpoke1"
  resource_group_name       = azurerm_resource_group.rg_network.name
  virtual_network_name      = azurerm_virtual_network.vnet_spoke_1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_hub.id
  allow_forwarded_traffic   = true
  use_remote_gateways = true
}