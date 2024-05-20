provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

module "resource_group" {
  for_each = var.resource_groups

  source              = "./modules/azure_rg"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
}

module "virtual_network" {
  for_each = var.virtual_networks

  source               = "./modules/azure_vnet"
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  virtual_network_name = each.value.virtual_network_name
  address_space        = each.value.address_space

  depends_on = [module.resource_group]
}
