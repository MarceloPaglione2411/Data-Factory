resource "azurerm_storage_account" "mod-sraccount1" {
  name                     = var.storage1_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = var.tier_name
  account_replication_type = var.replication_type
}

resource "azurerm_storage_container" "mod-container1" {
  name                  = var.container1_name
  storage_account_id    = azurerm_storage_account.mod-sraccount1.id
  container_access_type = var.access_type_name
}

resource "azurerm_storage_account" "mod-sraccount2" {
  name                     = var.storage2_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = var.tier_name
  account_replication_type = var.replication_type
}

resource "azurerm_storage_container" "mod-container2" {
  name                  = var.container2_name
  storage_account_id    = azurerm_storage_account.mod-sraccount2.id
  container_access_type = var.access_type_name
}
