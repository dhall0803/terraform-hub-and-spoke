# Create and associate route table 

resource "azurerm_route_table" "rt_all" {
  name                = "rt-all-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name

  route {
    name                   = "DefaultToAzureFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "spoke1-rta" {
  subnet_id      = azurerm_subnet.snet-workload1.id
  route_table_id = azurerm_route_table.rt_all.id
}

resource "azurerm_subnet_route_table_association" "spoke2-rta" {
  subnet_id      = azurerm_subnet.snet-workload2.id
  route_table_id = azurerm_route_table.rt_all.id
}

# Create route to on prem

resource "azurerm_route_table" "rt_hub" {
  name                = "rt-hub-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_onprem.name


  route {
    name                   = "ToOnprem"
    address_prefix         = "172.16.0.0/16"
    next_hop_type          = "VirtualNetworkGateway"
  }

  route {
    name                   = "ToInternet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
}

resource "azurerm_subnet_route_table_association" "hub_rta" {
  subnet_id      = azurerm_subnet.snet-fw.id
  route_table_id = azurerm_route_table.rt_hub.id
}