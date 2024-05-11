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

variable "location" {
  type    = string
  default = "japaneast"
}

variable "resource_group_name" {
  type    = string
  default = "learn-rg"
}

resource "azurerm_resource_group" "resource_groups" {
  count    = 3
  location = var.location
  name     = "${var.resource_group_name}-${format("%03d", count.index + 1)}"
}

