variable "location" {
  type = string
  default = "westeurope"
}

variable "zones" {
  type = list(string)
  default = [1,2,3]
}

variable "ssh-source-address" {
  type = string
  default = "79.148.156.201"
}