// Variables for the VNet and subnets module
variable "resource_group_name" {
  description = "The name of the resource group where the resources will be created"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network to be created"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnets to create. Each subnet should be a map with keys: name, address_prefixes, nsg_rules, route_table_routes"
  type = list(object({
    name             = string
    address_prefixes = list(string)
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
    route_table_routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  }))
}

// Create Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


// Create VNet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Resource block for subnets, NSGs, and route tables
resource "azurerm_subnet" "subnet" {
  for_each             = { for subnet in var.subnets : subnet.name => subnet }
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = each.value.name
  address_prefixes     = each.value.address_prefixes

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

// Create Network Security Groups
resource "azurerm_network_security_group" "nsg" {
  for_each            = { for subnet in var.subnets : subnet.name => subnet if length(subnet.nsg_rules) > 0 }
  name                = "${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Flatten NSG Rules
locals {
  nsg_rules = flatten([
    for subnet in var.subnets : [
      for rule in subnet.nsg_rules : {
        subnet_name = subnet.name
        rule_name   = rule.name
        rule        = rule
      }
    ]
  ])
}

// Create NSG Rules
resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = {
    for rule in local.nsg_rules : "${rule.subnet_name}-${rule.rule_name}" => rule
  }
  name                        = each.value.rule.name
  priority                    = each.value.rule.priority
  direction                   = each.value.rule.direction
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = each.value.rule.source_port_range
  destination_port_range      = each.value.rule.destination_port_range
  source_address_prefix       = each.value.rule.source_address_prefix
  destination_address_prefix  = each.value.rule.destination_address_prefix
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.subnet_name].name

  depends_on = [azurerm_network_security_group.nsg]
}

// Create Route Tables
resource "azurerm_route_table" "rt" {
  for_each            = { for subnet in var.subnets : subnet.name => subnet if length(subnet.route_table_routes) > 0 }
  name                = "${each.key}-rt"
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

// Flatten Routes
locals {
  routes = flatten([
    for subnet in var.subnets : [
      for route in subnet.route_table_routes : {
        subnet_name = subnet.name
        route_name  = route.name
        route       = route
      }
    ]
  ])
}

// Create Routes
resource "azurerm_route" "route" {
  for_each = {
    for route in local.routes : "${route.subnet_name}-${route.route_name}" => route
  }
  name                   = each.value.route.name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt[each.value.subnet_name].name

  depends_on = [azurerm_route_table.rt]
}

// Associate NSGs and Route Tables with subnets
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each                  = { for subnet in var.subnets : subnet.name => subnet if length(subnet.nsg_rules) > 0 }
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

  depends_on = [azurerm_subnet.subnet, azurerm_network_security_group.nsg]
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each       = { for subnet in var.subnets : subnet.name => subnet if length(subnet.route_table_routes) > 0 }
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rt[each.key].id

  depends_on = [azurerm_subnet.subnet, azurerm_route_table.rt]
}

// Outputs
output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = { for s in azurerm_subnet.subnet : s.name => s.id }
}

output "subnet_names" {
  description = "The names of the created subnets"
  value       = { for s in azurerm_subnet.subnet : s.name => s.name }
}

output "nsg_ids" {
  description = "The IDs of the created Network Security Groups"
  value       = { for nsg in azurerm_network_security_group.nsg : nsg.name => nsg.id }
}

output "route_table_ids" {
  description = "The IDs of the created Route Tables"
  value       = { for rt in azurerm_route_table.rt : rt.name => rt.id }
}
