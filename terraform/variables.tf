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
