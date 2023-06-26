variable "location" {
  type    = string
  default = "eastus"
}

variable "zones" {
  type    = list(string)
  default = []
}
variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "prefix" {
  type = string
  default = "demo"
}