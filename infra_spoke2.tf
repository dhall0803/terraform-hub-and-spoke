# Create spoke 2 network

resource "azurerm_virtual_network" "vnet_spoke_2" {
  name                = "vnet-spoke-hubandspoketest-dev-uksouth-002"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.20.2.0/24"]
}

# Create workload subnet

resource "azurerm_subnet" "snet-workload2" {
  name                 = "snet-workload-dev-uksouth-002"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_2.name
  address_prefixes     = ["10.20.2.0/24"]
}

# Peer  hub to spoke 2

resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                      = "Spoke2ToHub"
  resource_group_name       = azurerm_resource_group.rg_network.name
  virtual_network_name      = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_spoke_2.id
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                      = "HubToSpoke2"
  resource_group_name       = azurerm_resource_group.rg_network.name
  virtual_network_name      = azurerm_virtual_network.vnet_spoke_2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet_hub.id
  allow_forwarded_traffic = true
}