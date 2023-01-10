variable "default_inbound_rules" {
  type        = list(any)
  description = "List of default inbound rules to insert in all NSGs."
  default = [
    {
      priority = 4095
      name     = "A-IN-AzureLoadBalancer"
      src      = ["AzureLoadBalancer"]
      dst      = ["vnet_address_space"]
      protocol = "*"
      port     = ["*"]
      access   = "Allow"
      desc     = "Default rule - Allow Azure Load Balancer"
    },
    {
      priority = 4096
      name     = "D-IN-ALL"
      src      = ["*"]
      dst      = ["*"]
      protocol = "*"
      port     = ["*"]
      access   = "Deny"
      desc     = "Default Rule - Deny all."
    }
  ]
}
