terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
  features {

  }
}

locals {
  location = "uksouth"
}

# Create network resource group

resource "azurerm_resource_group" "rg_network" {
  name     = "rg-hubandspoketest-networking-dev-uksouth"
  location = local.location
}