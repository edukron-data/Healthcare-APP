resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_user
  administrator_password = var.admin_password
  sku_name               = var.sku_name
  storage_mb             = var.storage_gb * 1024
  backup_retention_days  = 7
  delegated_subnet_id    = var.subnet_id
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.pg.id
}

output "fqdn" {
  value     = azurerm_postgresql_flexible_server.pg.fqdn
  sensitive = true
}
