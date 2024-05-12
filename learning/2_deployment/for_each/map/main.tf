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

variable "resource_groups" {
  type = map(object({
    location : string
    instance_count : number
  }))
  default = {
    "us-east" = {
      location       = "East US",
      instance_count = 1
    },
    "jp-east" = {
      location       = "Japan East",
      instance_count = 1
    },
    "ko-central" = {
      location       = "Korea Central",
      instance_count = 1
    }
  }
}

locals {
  # 각 지역의 인스턴스 목록을 생성
  instances = flatten([
    for loc, specs in var.resource_groups : [
      for index in range(specs.instance_count) : {
        key      = "${loc}-${format("%03d", index + 1)}"
        location = specs.location
      }
    ]
  ])
}

resource "azurerm_resource_group" "rg" {
  # flatten으로 생성된 인스턴스 리스트에서 각 항목을 고유 키와 매핑
  for_each = { for inst in local.instances : inst.key => inst }

  name     = "${var.name_prefix}-rg-${each.value.key}"
  location = each.value.location
}
