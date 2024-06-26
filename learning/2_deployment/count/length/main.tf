# Version
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.96.0"
    }
  }
}

# Variables
variable "location" {
  type    = string
  default = "japaneast"
}

variable "resource_group_names" {
  type = list(string)
  default = [
    "learn-rg-001",
    "learn-rg-002",
    "learn-rg-003"
  ]
}

# Resource Groups
resource "azurerm_resource_group" "resource_groups" {
  count    = length(var.resource_group_names)
  location = var.location
  name     = var.resource_group_names[count.index]
}

