variable "location" {
  default = "spaincentral"
  type = string
  description = ""
}


variable "vnet_name" {
  default = "my-vnet"
}

variable "vnet_cidr" {
  type = string
  default = "10.0.0.0/16"
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

  default = {
    "public-subnet" = {
      new_bits = 8
      nsg = {
        name = "nsg-public"
        rules = [
          {
            name                       = "Allow-HTTP"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "80"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          },
          {
            name                       = "Allow-HTTPS"
            priority                   = 110
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "443"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        ]
      }
    }

    "private-subnet" = {
      new_bits = 8
      nsg = {
        name = "nsg-private"
        rules = [
          {
            name                       = "Deny-Internet"
            priority                   = 100
            direction                  = "Outbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "Internet"
          }
        ]
      }
    }
  }
}



variable "subscription_id" {
  default = "<your-subscription-id-here>"
  description = "provide the subscription where you provision put this vnet"
  type = string
}

variable "rg_name" {
  default = "<your-resource-group-name-here>"
  description = "name of resource group where you wanna provision the vnet"
  type = string
}
