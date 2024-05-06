resource "azurerm_resource_group" "hub_rg" {
  provider = azurerm.hub
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "hub_vnet" {
  depends_on = [azurerm_resource_group.hub_rg]

  provider            = azurerm.hub
  name                = "hubVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnet
  ]

  provider                     = azurerm.hub
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.hub_rg.name
  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "null_resource" "hub_peering_async" {
  depends_on = [azurerm_virtual_network.hub_vnet]

  triggers = {
    spoke_vnet_addr = join(",", azurerm_virtual_network.spoke_vnet.address_space)
  }

  provisioner "local-exec" {
    command = <<CMD
    az network vnet peering sync --ids ${azurerm_virtual_network_peering.hub_to_spoke.id}
    CMD
  }
}
