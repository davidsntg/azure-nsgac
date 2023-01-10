data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                 = var.vnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "subnets" {
  count                = length(data.azurerm_virtual_network.vnet.subnets)

  name                 = data.azurerm_virtual_network.vnet.subnets[count.index]
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name   
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${data.azurerm_virtual_network.vnet.name}-nsg"
  location            = data.azurerm_virtual_network.vnet.location
  resource_group_name = data.azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each   = {for i, v in concat(var.vnet_inbound_rules, var.default_inbound_rules):  i => v} 

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = "Inbound"
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = "*"
      destination_port_range       = length(flatten(security_rule.value.port)) == 1 ? security_rule.value.port[0] : ""
      destination_port_ranges      = length(flatten(security_rule.value.port)) > 1 ? flatten(security_rule.value.port) : []
      source_address_prefixes      = (length(flatten(security_rule.value.src)) > 1) || (contains(flatten(security_rule.value.src), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) > 1) ? flatten([for item in flatten(security_rule.value.src): split(" ", replace(item, "vnet_address_space", join(" ", data.azurerm_virtual_network.vnet.address_space)))]) : []
      source_address_prefix        = (length(flatten(security_rule.value.src)) == 1 && !contains(flatten(security_rule.value.src), "vnet_address_space")) || (contains(flatten(security_rule.value.src), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) == 1) ? replace(flatten(security_rule.value.src)[0], "vnet_address_space", data.azurerm_virtual_network.vnet.address_space[0]) : ""
      destination_address_prefixes = (length(flatten(security_rule.value.dst)) > 1) || (contains(flatten(security_rule.value.dst), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) > 1) ? flatten([for item in flatten(security_rule.value.dst): split(" ", replace(item, "vnet_address_space", join(" ", data.azurerm_virtual_network.vnet.address_space)))]) : []
      destination_address_prefix   = (length(flatten(security_rule.value.dst)) == 1 && !contains(flatten(security_rule.value.dst), "vnet_address_space")) || (contains(flatten(security_rule.value.dst), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) == 1) ? replace(flatten(security_rule.value.dst)[0], "vnet_address_space", data.azurerm_virtual_network.vnet.address_space[0]) : ""
      description                  = security_rule.value.desc
    }
  }

  dynamic "security_rule" {
    for_each   = {for i, v in concat(var.vnet_outbound_rules, var.default_outbound_rules):  i => v} 

    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = "Outbound"
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = "*"
      destination_port_range       = length(flatten(security_rule.value.port)) == 1 ? security_rule.value.port[0] : ""
      destination_port_ranges      = length(flatten(security_rule.value.port)) > 1 ? flatten(security_rule.value.port) : []
      source_address_prefixes      = (length(flatten(security_rule.value.src)) > 1) || (contains(flatten(security_rule.value.src), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) > 1) ? flatten([for item in flatten(security_rule.value.src): split(" ", replace(item, "vnet_address_space", join(" ", data.azurerm_virtual_network.vnet.address_space)))]) : []
      source_address_prefix        = (length(flatten(security_rule.value.src)) == 1 && !contains(flatten(security_rule.value.src), "vnet_address_space")) || (contains(flatten(security_rule.value.src), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) == 1) ? replace(flatten(security_rule.value.src)[0], "vnet_address_space", data.azurerm_virtual_network.vnet.address_space[0]) : ""
      destination_address_prefixes = (length(flatten(security_rule.value.dst)) > 1) || (contains(flatten(security_rule.value.dst), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) > 1) ? flatten([for item in flatten(security_rule.value.dst): split(" ", replace(item, "vnet_address_space", join(" ", data.azurerm_virtual_network.vnet.address_space)))]) : []
      destination_address_prefix   = (length(flatten(security_rule.value.dst)) == 1 && !contains(flatten(security_rule.value.dst), "vnet_address_space")) || (contains(flatten(security_rule.value.dst), "vnet_address_space") && length(data.azurerm_virtual_network.vnet.address_space) == 1) ? replace(flatten(security_rule.value.dst)[0], "vnet_address_space", data.azurerm_virtual_network.vnet.address_space[0]) : ""
      description                  = security_rule.value.desc
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = toset([for subnet in data.azurerm_subnet.subnets: subnet.id if !contains(var.excluded_subnets_nsg, subnet.name)])

  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.nsg.id
}
