# Common

variable "prefix" {
  type    = string
  default = "learn"
}

# Resource groups
variable "resource_groups" {
  type = map(object({
    resource_group_name = string
    location            = string
  }))

  default = {
    "rg-1" = {
      resource_group_name = "rg-${var.prefix}-1"
      location            = "Japan East"
    }
    "rg-2" = {
      resource_group_name = "rg-${var.prefix}-2"
      location            = "Japan East"
    }
  }
}

# Virtual networks
variable "virtual_networks" {
  type = map(object({
    resource_group_name  = string
    location             = string
    virtual_network_name = string
    address_space        = []
  }))

  default = {
    "vnet-1" = {
      resource_group_name  = resource_groups.rg-1.resource_group_name
      location             = resource_groups.rg-1.location
      virtual_network_name = "vnet-${var.prefix}-1"
      address_space = [
        "10.0.0.0/8"
      ]
    }
    "vnet-2" = {
      resource_group_name  = resource_groups.rg-2.resource_group_name
      location             = resource_groups.rg-2.location
      virtual_network_name = "vnet-${var.prefix}-2"
      address_space = [
        "10.0.0.0/8"
      ]
    }
  }
}
