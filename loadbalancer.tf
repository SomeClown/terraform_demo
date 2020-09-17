# Azure Load Balancer Frontend
resource "azurerm_lb" "demo" {
    name                        = "AzureLoadBalancer"
    location                    = var.location
    resource_group_name         = "${azurerm_resource_group.demo.name}"
    frontend_ip_configuration {
        name                    = "publicIP"
        public_ip_address_id    = "${azurerm_public_ip.demo.id}"
    }
    tags     = "${var.tags}"
}

# Azure Load Balancer Backend
resource "azurerm_lb_backend_address_pool" "demo" {
    name = "BackEndAddressPool"
    resource_group_name         = "${azurerm_resource_group.demo.name}"
    loadbalancer_id             = "${azurerm_lb.demo.id}"
}

# Probe
resource "azurerm_lb_probe" "demo" {
    resource_group_name         = "${azurerm_resource_group.demo.name}"
    loadbalancer_id             = "${azurerm_lb.demo.id}"
    name                        = "ssh-probe"
    port                        = 22
}

# SSH rule
resource "azurerm_lb_rule" "sshlbrule" {
    frontend_ip_configuration_name = "publicIP"
    frontend_port = 22
    backend_port = 22
    name = "ssh-LB-Rule"
    protocol = "tcp"
    loadbalancer_id = "${azurerm_lb.demo.id}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    probe_id = "${azurerm_lb_probe.demo.id}"
    backend_address_pool_id = "${azurerm_lb_backend_address_pool.demo.id}"
}

# HTTP Rule
resource "azurerm_lb_rule" "weblbrule" {
    frontend_ip_configuration_name = "publicIP"
    frontend_port = 80
    backend_port = 80
    name = "web-LB-Rule"
    protocol = "tcp"
    loadbalancer_id = "${azurerm_lb.demo.id}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    probe_id = "${azurerm_lb_probe.demo.id}"
    backend_address_pool_id = "${azurerm_lb_backend_address_pool.demo.id}"
}

# HTTP Rule (2)
resource "azurerm_lb_rule" "weblbrule2" {
    frontend_ip_configuration_name = "publicIP"
    frontend_port = 8080
    backend_port = 8080
    name = "web-LB-Rule2"
    protocol = "tcp"
    loadbalancer_id = "${azurerm_lb.demo.id}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    probe_id = "${azurerm_lb_probe.demo.id}"
    backend_address_pool_id = "${azurerm_lb_backend_address_pool.demo.id}"
}

# HTTP Rule
resource "azurerm_lb_rule" "weblbrule3" {
    frontend_ip_configuration_name = "publicIP"
    frontend_port = 443
    backend_port = 443
    name = "web-LB-Rule3"
    protocol = "tcp"
    loadbalancer_id = "${azurerm_lb.demo.id}"
    resource_group_name = "${azurerm_resource_group.demo.name}"
    probe_id = "${azurerm_lb_probe.demo.id}"
    backend_address_pool_id = "${azurerm_lb_backend_address_pool.demo.id}"
}