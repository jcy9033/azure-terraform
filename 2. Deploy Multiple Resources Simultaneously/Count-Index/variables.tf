variable "location" {
  type    = string
  default = "japaneast"
}

variable "resource_group_names" {
  type = list(string)
  default = [
    "learn-rg-1",
    "learn-rg-2"
  ]
}
