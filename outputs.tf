output "subnet_ids_map" {
  description = "Map of subnet names to subnet IDs"
  value = local.vnet_subnets
}