resource_group_name = "learn-rg"
location            = "Japan East"
vnet_name           = "learn-vnet"
vnet_address_space  = ["10.0.0.0/16"]
subnets = [
  {
    name             = "subnet-1"
    address_prefixes = ["10.0.1.0/24"]
    nsg_rules = [
      # Inbound rules
      {
        name                       = "allow_ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    route_table_routes = [
      {
        name                   = "route-1"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "Internet"
        next_hop_in_ip_address = null
      }
    ]
  },
  {
    name               = "subnet-2"
    address_prefixes   = ["10.0.2.0/24"]
    nsg_rules          = [
      # Inbound rules
      {
        name                       = "allow_ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    route_table_routes = [
      {
        name                   = "route-1"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "Internet"
        next_hop_in_ip_address = null
      }
    ]
  }
]
