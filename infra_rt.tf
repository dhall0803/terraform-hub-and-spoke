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