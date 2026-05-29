output "acr_login_server" {
  value = module.acr.login_server
}

output "keyvault_id" {
  value = module.keyvault.key_vault_id
}

output "postgres_fqdn" {
  value = module.postgres.fqdn
}

output "aks_kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
