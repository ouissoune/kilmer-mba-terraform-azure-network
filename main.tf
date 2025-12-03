module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vnet_cidr

  networks = flatten([
  for k, v in var.subnets : [
    {
      name     = k
      new_bits = v.new_bits
    }
  ]
  ])
}

resource "random_pet" "vnet_suffix" {
  length    = 2
  separator = "-"
}


module "avm-res-network-virtualnetwork" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"

  address_space = [var.vnet_cidr]
  location      = var.location
  name          = "${var.vnet_name}-${var.location}-${random_pet.vnet_suffix.id}"
  parent_id     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}"

  subnets = {
  for s in module.subnets.networks :
  s.name => {
    name             = s.name
    address_prefixes = [s.cidr_block]
  }
  }
}


