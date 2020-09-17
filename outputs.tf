# Key Outputs

# Jumpbox FQDN
output "Jumpbox_Public_FQDN" {
   value = "${azurerm_public_ip.jumpbox.fqdn}"
}

# Jumpbox Public IP
output "Jumpbox_Frontend_IP" {
  value = "${azurerm_public_ip.jumpbox.ip_address}"
}

# Load Balancer Public FQDN
output "LoadBalancer_Frontend_FQDN" {
  value = "${azurerm_public_ip.demo.fqdn}"
}

# Load Balancer Public IP
output "LoadBalancer_Frontend_IP" {
  value = "${azurerm_public_ip.demo.ip_address}"
}
# Load Balancer Private IP
output "LoadBalancer_Private__IP_Addresses" {
  value = "${azurerm_network_interface.demo.*.private_ip_addresses}"
}

# App Server 1 Private IP
output "AppServer1_Private_IP_Address" {
  value = "${azurerm_network_interface.demo_app1.private_ip_address}"
}

# App Server 2 Private IP
output "AppServer2_Private_IP_Address" {
  value = "${azurerm_network_interface.demo_app2.private_ip_address}"
}

