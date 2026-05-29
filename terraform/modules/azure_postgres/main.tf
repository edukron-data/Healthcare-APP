resource "azurerm_postgresql_flexible_server" "pg" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login = var.admin_user
  administrator_password = var.admin_password
  sku_name = var.sku_name

  storage {
    storage_size_gb = var.storage_gb
  }

  high_availability {
    mode = "Disabled"
  }

  network {
    delegated_subnet_id = var.subnet_id
  }

  backup {
    retention_days = 7
  }
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_flexible_server.pg.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.pg.fqdn
  sensitive = true
}
