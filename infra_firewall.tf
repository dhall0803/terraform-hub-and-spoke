# Create Azure Firewall

resource "azurerm_public_ip" "pip_fw" {
  name                = "pip-firewall"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "afw" {
  name                = "fw-hubandspoketest-dev-uksouth-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg_network.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "fw-ip-config"
    subnet_id            = azurerm_subnet.snet-fw.id
    public_ip_address_id = azurerm_public_ip.pip_fw.id
  }
}

resource "azurerm_firewall_network_rule_collection" "example" {
  name                = "NetworkRules"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = azurerm_resource_group.rg_network.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "AllowVirtualNetworkToVirtualNetwork"

    source_addresses = [
      "10.20.0.0/16"
    ]

    destination_ports = [
      "*"
    ]

    destination_addresses = [
      "10.20.0.0/16"
    ]

    protocols = [
      "Any"
    ]
  }

  rule {
    name = "AllowVirtualNetworkToOnPrem"

    source_addresses = [
      "10.20.0.0/16"
    ]

    destination_ports = [
      "*"
    ]

    destination_addresses = [
      "172.16.0.0/16"
    ]

    protocols = [
      "Any"
    ]
  }

  rule {
    name = "AllowOnPremToVirtualNetwork"

    source_addresses = [
      "172.16.0.0/16"
    ]

    destination_ports = [
      "*"
    ]

    destination_addresses = [
      "10.20.0.0/16"
    ]

    protocols = [
      "Any"
    ]
  }
}