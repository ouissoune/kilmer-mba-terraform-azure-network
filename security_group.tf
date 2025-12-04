resource "azurerm_network_security_group" "nsgs" {
  for_each = { for name, cfg in var.subnets : name => cfg if length(cfg.nsg.rules) > 0 }

  name                = each.value.nsg.name
  location            = var.location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = each.value.nsg.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each = { for name, cfg in var.subnets : name => cfg if length(cfg.nsg.rules) > 0 }

  subnet_id                 = module.avm-res-network-virtualnetwork.subnets[each.key].resource_id
  network_security_group_id = azurerm_network_security_group.nsgs[each.key].id
}