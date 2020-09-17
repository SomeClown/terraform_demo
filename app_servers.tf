# Availability Set
resource "azurerm_availability_set" "app_avset" {
    location = var.location
    name                            = "app_avset"
    resource_group_name             = "${azurerm_resource_group.demo.name}"
    platform_update_domain_count    = 2
    platform_fault_domain_count     = 2
    managed                         = true
    tags     = "${var.tags}"
}

# Create vNIC 1
resource "azurerm_network_interface" "demo_app1" {
  name                      = "appNIC1"
  location                  = var.location
  resource_group_name       = "${azurerm_resource_group.demo.name}"
  network_security_group_id = "${azurerm_network_security_group.lb_security.id}"
  ip_configuration {
    name                          = "App1NicConfiguration"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.10"
  }
  tags     = "${var.tags}"
}

# Create vNIC 2
resource "azurerm_network_interface" "demo_app2" {
  name                      = "appNIC2"
  location                  = var.location
  resource_group_name       = "${azurerm_resource_group.demo.name}"
  network_security_group_id = "${azurerm_network_security_group.lb_security.id}"
  ip_configuration {
    name                          = "App2NicConfiguration"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.11"
  }
  tags     = "${var.tags}"
}

#  Create Application VM 1
resource "azurerm_virtual_machine" "appserver1" {
  name                          = "appserver1"
  count                         = 1
  location                      = var.location
  availability_set_id           = "${azurerm_availability_set.app_avset.id}"
  resource_group_name           = "${azurerm_resource_group.demo.name}"
  network_interface_ids         = ["${element(azurerm_network_interface.demo_app1.*.id, count.index)}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  tags                          = "${var.tags}"

  storage_os_disk {
    name = "appdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version = "latest"
  }
  os_profile {
    computer_name = "appserver1"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data = "${file("app1.conf")}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled = "true"
    storage_uri = "${azurerm_storage_account.demo.primary_blob_endpoint}"
  }

}

#  Create Application VM 2
resource "azurerm_virtual_machine" "appserver2" {
  name                           = "appserver2"
  count                          = 1
  location                       = var.location
  availability_set_id            = "${azurerm_availability_set.app_avset.id}"
  resource_group_name            = "${azurerm_resource_group.demo.name}"
  network_interface_ids          = ["${element(azurerm_network_interface.demo_app2.*.id, count.index)}"]
  vm_size                        = "Standard_DS1_v2"
  delete_os_disk_on_termination  = true
  tags                           = "${var.tags}"

  storage_os_disk {
    name              = "appdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }
  os_profile {
    computer_name   = "appserver2"
    admin_username  = "${var.admin_username}"
    admin_password  = "${var.admin_password}"
    custom_data     = "${file("app2.conf")}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
      enabled = "true"
      storage_uri = "${azurerm_storage_account.demo.primary_blob_endpoint}"
  }

}