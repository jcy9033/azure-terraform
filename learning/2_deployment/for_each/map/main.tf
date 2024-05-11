provider "azurerm" {
  features {
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.96.0"
    }
  }
}

variable "name_prefix" {
  type    = string
  default = "learn"
}

variable "regions" {
  type = map(object({
    location : string
    instance_count : number
  }))
  default = {
    "us-east"    = { location = "East US", instance_count = 2 },
    "jp-east"    = { location = "Japan East", instance_count = 2 },
    "ko-central" = { location = "Korea Central", instance_count = 2 }
  }

  validation {
    condition     = alltrue([for _, region in var.regions : contains(["East US", "Japan East", "Korea Central"], region.location)])
    error_message = "Each region's location must be 'East US', 'Japan East', or 'Korea Central'."
  }
}


resource "azurerm_resource_group" "rg" {
  for_each = var.regions
  name     = "${var.name_prefix}-rg-${each.key}"
  location = each.value.location
}
