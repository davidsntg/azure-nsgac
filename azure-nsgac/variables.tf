variable "resource_group_name" {
    description = "Name of the resource group"
    type = string
}


variable "vnet_name" {
    description = "Name of the virtual network"
    type = string
}

variable "excluded_subnets_nsg" {
  type = list
  description = "List of subnets in the vnet that should not be associated with the created NSG."
  default = []
}

variable "default_inbound_rules" {
  type = list
  description = "List of default inbound security rules to insert in all NSGs."
  default = []
}

variable "default_outbound_rules" {
  type = list
  description = "List of default outbound security rules to insert in all NSGs."
  default = []
}

variable "vnet_inbound_rules" {
    type = list
    description = "Vnet inbound security rules to create."
    default = []
}

variable "vnet_outbound_rules" {
    type = list
    description = "Vnet outbound security rules to create."
    default = []
}