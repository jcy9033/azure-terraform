module "network" {
  source              = "./modules/networks"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  subnets             = var.subnets
}

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
