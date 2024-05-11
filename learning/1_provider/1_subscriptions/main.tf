# Hub Subscription
resource "azurerm_resource_group" "hub_rg" {
  provider = azurerm.hub
  location = var.location
  name     = var.resource_group_name
}

# Spoke Subscription
resource "azurerm_resource_group" "spoke_rg" {
  provider = azurerm.spoke
  location = var.location
  name     = var.resource_group_name
}
