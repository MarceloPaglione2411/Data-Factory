variable "rg_name" {
    description = "Localização Resource Group"
    type = string
}

variable "rg_location" {
    description = "Localização Resource Group"
    type = string
}

variable "storage1_name" {
    description = "Nome Storage Account1 "
    type = string
}

variable "container1_name" {
    description = "Nome container1"
    type = string
}

variable "storage2_name" {
    description = "Nome Storage Account2 "
    type = string
}

variable "container2_name" {
    description = "Nome container1"
    type = string
}

variable "tier_name" {
    description = "Tier do Storage Account"
    type = string
}

variable "replication_type" {
    description = "Tipo replicação do Storage Account"
    type = string
}

variable "access_type_name" {
    description = "Tipo de acesso Container"
    type = string
}
