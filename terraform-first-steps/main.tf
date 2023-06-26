provider "azurerm" {
features {
  
    }
}

#Create a resource group
resource "azurerm_resource_group" "demoterraform" {
  name = "${var.prefix}-first-steps"
  location = var.location
}

variable "myvar" {
    type  = string
    default = "Hello Terraform"
}

variable "mymap" {
    type  = map(string)
    default = {
        mykey = "my value"
    }
}

variable "mylist" {
    type = list(number)
    default = [4,3,5,1,2]
}

variable "myset" {
  type = set(number)
  default = [1,2,3]
}   

variable "myobject" {
    type = object({firstname = string, housenumber = number})
    default = {
        firstname = "John"
        housenumber = 10
    }
}

variable "mytuple" {
    type = tuple([number,string])
    default = [4, "september"]
}