provider "azurerm" {
  features {}
  subscription_id = "611a7ed8-17fa-480a-901d-d7084803c376"
  alias           = "subscriptionA"
}

provider "azurerm" {
  features {}
  subscription_id = "0b5f5005-c30c-4a28-89c1-9457d0cd5e0f"
  alias           = "subscriptionB"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.96.0"
    }
  }
}
