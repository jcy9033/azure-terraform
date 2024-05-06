resource "azurerm_resource_group" "subscriptionA_rg" {
  count    = length(var.resource_group_names)
  provider = azurerm.subscriptionA
  location = var.location
  name     = var.resource_group_names[count.index]
}

resource "azurerm_resource_group" "subscriptionB_rg" {
  count    = length(var.resource_group_names)
  provider = azurerm.subscriptionB
  location = var.location
  name     = var.resource_group_names[count.index]
}
