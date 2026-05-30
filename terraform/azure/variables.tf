# Base variables
variable "location" {
  type    = string
  default = "eastus"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "prefix" {
  type    = string
  default = "healthcare"
}

# Network variables
variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

# ACR variables
variable "acr_name" {
  type = string
}

variable "acr_sku" {
  type    = string
  default = "Standard"
}

# Key Vault variables
variable "keyvault_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "keyvault_secret_name" {
  type = string
}

variable "keyvault_secret_value" {
  type      = string
  sensitive = true
}

# PostgreSQL variables
variable "postgres_server_name" {
  type = string
}

variable "postgres_admin_user" {
  type = string
}

variable "postgres_admin_password" {
  type      = string
  sensitive = true
}

variable "postgres_sku" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "postgres_storage_gb" {
  type    = number
  default = 32
}

variable "postgres_database_name" {
  type = string
}

# AKS variables
variable "aks_cluster_name" {
  type = string
}

variable "aks_node_count" {
  type    = number
  default = 3
}

variable "aks_node_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "aks_min_count" {
  type    = number
  default = 1
}

variable "aks_max_count" {
  type    = number
  default = 5
}
