variable "default_outbound_rules" {
  type        = list(any)
  description = "List of default outbound rules to insert in all NSGs."
  default = [
    {
      priority = 4096
      name     = "D-OU-ALL"
      src      = ["*"]
      dst      = ["*"]
      protocol = "*"
      port     = ["*"]
      access   = "Deny"
      desc     = "Default Rule - Deny all."
    }
  ]
}