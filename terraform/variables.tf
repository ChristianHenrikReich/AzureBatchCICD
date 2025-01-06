variable "project_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "environment" {
  description = "dev, tst or prd, to descripe development, test or production. More can be added, recommendation is to keep 3 letters"
  type        = string
}


variable "vm_sku" {
  description = "Azure VM Sku"
  type        = string
}

variable "nodes" {
  description = "Number of dedicated nodes"
  type        = number
}

variable "spot_nodes" {
  description = "Number of spot nodes"
  type        = number
}
