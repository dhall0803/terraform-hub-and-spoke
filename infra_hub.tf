# Create hub network

resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.20.0.0/24"]
}

# Create firewall subnet

resource "azurerm_subnet" "snet-fw" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.20.0.0/26"]
}

# Create VPN Subnet

resource "azurerm_subnet" "snet-vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.20.0.64/27"]
}

# Create Bastion subnet

resource "azurerm_subnet" "snet-bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.20.0.128/26"]
}