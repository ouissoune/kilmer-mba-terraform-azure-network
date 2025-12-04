variable "location" {
  type        = string
  description = "Azure region where the virtual network will be deployed (e.g., 'East US')"
}

variable "vnet_name" {
  type        = string
  description = "Name of the virtual network to create"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the virtual network (e.g., '10.0.0.0/16')"
}

variable "subnets" {
  type = map(object({
    new_bits = number

    # NSG per subnet: name + list of rules
    nsg = object({
      name  = string
      rules = list(object({
        name                       = string
        priority                   = number
        direction                  = string   # "Inbound" or "Outbound"
        access                     = string   # "Allow" or "Deny"
        protocol                   = string   # "Tcp", "Udp", "*"
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      }))
    })
  }))
  description = "Map of subnets to create in the virtual network. Each subnet includes new_bits for subnetting and optional NSG configuration"
}

variable "subscription_id" {
  default     = "<your-subscription-id-here>"
  description = "Azure subscription ID where the virtual network will be provisioned"
  type        = string
}

variable "rg_name" {
  default     = "<your-resource-group-name-here>"
  description = "Name of the Azure resource group where the virtual network will be created"
  type        = string
}

variable "organization_name" {
  type        = string
}
variable "rg_workspace_name" {
  type        = string
}

