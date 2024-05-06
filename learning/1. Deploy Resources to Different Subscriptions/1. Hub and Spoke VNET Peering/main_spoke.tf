resource "azurerm_resource_group" "spoke_rg" {
  provider = azurerm.spoke
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "spoke_vnet" {
  depends_on = [azurerm_resource_group.spoke_rg]

  provider            = azurerm.spoke
  name                = "spokeVnet"
  address_space       = ["10.1.0.0/16", "10.2.0.0/16"]
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  depends_on = [
    azurerm_virtual_network.spoke_vnet,
    azurerm_virtual_network.hub_vnet
  ]

  provider                     = azurerm.spoke
  name                         = "spoke-to-hub"
  resource_group_name          = azurerm_resource_group.spoke_rg.name
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  lifecycle {
    replace_triggered_by = [azurerm_virtual_network.hub_vnet.address_space, azurerm_virtual_network.spoke_vnet.address_space]
  }
}
