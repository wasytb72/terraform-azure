variable "location" {
  type = string
  default = "westeurope"
}

variable "prefix" {
  type = string
  default = "demo"
}

variable "ssh-source-address" {
    type = string
    default = "79.148.156.201/32"
}

variable "vm-size" {
  type = string
  default = "Standard_A1_v2"
}