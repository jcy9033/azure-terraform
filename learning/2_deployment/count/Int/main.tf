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

variable "resource_group_name" {
  type    = string
  default = "learn-rg"
}

variable "resource_group_count" {
  type    = number
  default = 3
}

# Resource Groups
resource "azurerm_resource_group" "resource_groups" {
  count    = var.resource_group_count
  location = var.location
  name     = "${var.resource_group_name}-${format("%03d", count.index + 1)}"
}

