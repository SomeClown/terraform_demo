# Create Security Group
resource "azurerm_network_security_group" "jumpbox_security" {
  name                = "JumpBoxSecurityGroup"
  location            = var.location
  resource_group_name = "${azurerm_resource_group.demo.name}"
  tags     = "${var.tags}"
}

resource "azurerm_network_security_rule" "jb_ssh_rule" {
  network_security_group_name = "${azurerm_network_security_group.jumpbox_security.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  name                       = "jb_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
}