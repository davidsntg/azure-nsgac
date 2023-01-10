variable "rfc_1918_cidrs" {
  type    = list(any)
  default = ["10.0.0.0/8", "176.16.0.0/12", "192.168.0.0/16"]
}

# App1 - Prod- VM Front 1 IP
variable "app1_vm_front1_ips" {
  type    = list(any)
  default = ["10.221.4.4"]
}

variable "app1_vm_front2_ips" {
  type    = list(any)
  default = ["10.221.4.5"]
}

variable "app1_vm_back_ips" {
  type    = list(any)
  default = ["10.221.4.20"]
}

variable "app1_vm_db_ips" {
  type    = list(any)
  default = ["10.221.4.36"]
}
