variable "resource_group_location" {
  type = string
  default = "westeurope"
  description = "Location of the resource group"
}

variable "resource_group_prefix" {
  type = string
  default = "demo-mysql-fs-rg"
  description = "Prefix of the resource groupo name thats combined with a random ID so the name is unique in Azure"
}

variable "ssh_source_address" {
  type = string
  default = "79.148.153.247"
}