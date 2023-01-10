module "vnet-prd-app1" {
  source = "./azure-nsgac"
  providers = {
    azurerm = azurerm.sub2
  }

  # VNet description
  resource_group_name = "prd-app1"
  vnet_name           = "vnet-prd-app1"
  #excluded_subnets_nsg = [""]

  # (Optionnal) Default Rules
  default_outbound_rules = var.default_outbound_rules
  default_inbound_rules  = var.default_inbound_rules

  # INBOUND RULES
  vnet_inbound_rules = [
    {
      priority = 1000
      name     = "A-IN-VM_Front2-VM_Front1"
      src      = var.app1_vm_front1_ips
      dst      = var.app1_vm_front2_ips
      protocol = "*"
      port     = ["*"]
      access   = "Allow"
      desc     = ""
    }
  ]

  # OUTBOUND RULES
  vnet_outbound_rules = [
    {
      priority = 1000
      name     = "A-OU-VNet-RFC1918"
      src      = ["vnet_address_space"]
      dst      = var.rfc_1918_cidrs
      protocol = "Udp"
      port     = ["53"]
      access   = "Allow"
      desc     = ""
    },
    {
      priority = 1001
      name     = "A-OU-VM_Back-VM_DB"
      src      = var.app1_vm_back_ips
      dst      = var.app1_vm_db_ips
      protocol = "Tcp"
      port     = ["5432"]
      access   = "Allow"
      desc     = ""
    }
  ]
}

