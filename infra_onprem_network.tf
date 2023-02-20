# Create "onprem" network

resource "azurerm_resource_group" "rg_onprem" {
  name     = "rg-hubandspoketest-onprem-dev-uksouth"
  location = "uksouth"
}

resource "azurerm_virtual_network" "vnet_on_prem" {
  name                = "vnet-spoke-onprem-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["172.16.0.0/24"]
}

# Create gateway subnet

resource "azurerm_subnet" "snet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_on_prem.name
  address_prefixes     = ["172.16.0.0/25"]
}

# Create workload subnet

resource "azurerm_subnet" "snet-workload3" {
  name                 = "snet-workload-dev-uksouth-003"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_on_prem.name
  address_prefixes     = ["172.16.0.128/25"]
}

# Create route to cloud

resource "azurerm_route_table" "rt_onprem" {
  name                = "rt-onrpem-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_onprem.name

  route {
    name                   = "CloudToVPN"
    address_prefix         = "10.20.0.0/16"
    next_hop_type          = "VirtualNetworkGateway"
  }
}

resource "azurerm_subnet_route_table_association" "route_to_cloud" {
  subnet_id      = azurerm_subnet.snet-workload3.id
  route_table_id = azurerm_route_table.rt_onprem.id
}



