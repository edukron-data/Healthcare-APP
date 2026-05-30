provider "azurerm" {
  features {}
}

module "network" {
  source              = "../modules/azure_network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_cidr           = var.vnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
}

module "acr" {
  source              = "../modules/azure_acr"
  acr_name            = var.acr_name
  resource_group_name = module.network.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
}

module "keyvault" {
  source              = "../modules/azure_keyvault"
  vault_name          = var.keyvault_name
  location            = var.location
  resource_group_name = module.network.resource_group_name
  tenant_id           = var.tenant_id
  secret_name         = var.keyvault_secret_name
  secret_value        = var.keyvault_secret_value
}

module "postgres" {
  source              = "../modules/azure_postgres"
  server_name         = var.postgres_server_name
  resource_group_name = module.network.resource_group_name
  location            = var.location
  admin_user          = var.postgres_admin_user
  admin_password      = var.postgres_admin_password
  sku_name            = var.postgres_sku
  storage_gb          = var.postgres_storage_gb
  subnet_id           = module.network.private_subnet_id
  database_name       = var.postgres_database_name
}

module "aks" {
  source              = "../modules/azure_aks"
  cluster_name        = var.aks_cluster_name
  location            = var.location
  resource_group_name = module.network.resource_group_name
  node_count          = var.aks_node_count
  node_vm_size        = var.aks_node_vm_size
  min_count           = var.aks_min_count
  max_count           = var.aks_max_count
}
