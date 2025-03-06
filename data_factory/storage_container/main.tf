module "rg_module" {
  source = "./resource_group"
  rg_name = var.rg_name
  rg_location = var.rg_location

}

module "storage" {
  source = "./storage"
  storage1_name = var.storage1_name
  storage2_name = var.storage2_name
  rg_name = module.rg_module.rg_name
  rg_location = module.rg_module.rg_location
  tier_name = var.tier_name
  replication_type = var.replication_type
  container1_name = var.container1_name
  container2_name = var.container2_name
  access_type_name = var.access_type_name
  

}
