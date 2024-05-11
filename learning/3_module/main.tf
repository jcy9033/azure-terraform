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

variable "resource_group_name" {
  type    = string
  default = "learn-modules-demo-rg"
}

variable "location" {
  type    = string
  default = "japaneast"
}



module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}
