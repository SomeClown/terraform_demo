# Create Security Group
resource "azurerm_network_security_group" "lb_security" {
  name                = "myNetworkSecurityGroup"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.demo.name}"
  tags     = "${var.tags}"
}

resource "azurerm_network_security_rule" "lb_ssh_rule" {
  network_security_group_name = "${azurerm_network_security_group.lb_security.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  name                       = "lb_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${azurerm_subnet.demo.address_prefix}"
    destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "http_rule1" {
  network_security_group_name = "${azurerm_network_security_group.lb_security.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  name                       = "lb_Web"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "http_rule2" {
  network_security_group_name = "${azurerm_network_security_group.lb_security.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  name                       = "lb_Web"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "https_rule" {
  network_security_group_name = "${azurerm_network_security_group.lb_security.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  name                       = "lb_Web"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}