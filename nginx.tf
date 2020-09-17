# Availability Set
resource "azurerm_availability_set" "avset1" {
    location = var.location
    name                            = "avset1"
    resource_group_name             = "${azurerm_resource_group.demo.name}"
    platform_update_domain_count    = 2
    platform_fault_domain_count     = 2
    managed                         = true
    tags     = "${var.tags}"
}

# Create vNICs
resource "azurerm_network_interface" "demo" {
  name                      = "lbNIC${count.index}"
  count                     = 2
  location                  = var.location
  resource_group_name       = "${azurerm_resource_group.demo.name}"
  network_security_group_id = "${azurerm_network_security_group.lb_security.id}"
  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "dynamic"
    private_ip_address = "10.0.2.${count.index}"
    load_balancer_backend_address_pools_ids         = ["${azurerm_lb_backend_address_pool.demo.id}"]
  }
  tags     = "${var.tags}"
}

#  Create nginx VMs
resource "azurerm_virtual_machine" "demo" {
  name                           = "lb${count.index}"
  count                          = 2
  location                       = var.location
  availability_set_id            = "${azurerm_availability_set.avset1.id}"
  resource_group_name            = "${azurerm_resource_group.demo.name}"
  network_interface_ids          = ["${element(azurerm_network_interface.demo.*.id, count.index)}"]
  vm_size                        = "Standard_DS1_v2"
  delete_os_disk_on_termination  = true
  tags                           = "${var.tags}"

  storage_os_disk {
    name              = "lbdisk${count.index}"
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
    computer_name   = "loadbalancer${count.index}"
    admin_username  = "${var.admin_username}"
    admin_password  = "${var.admin_password}"
    custom_data     = "${file("web.conf")}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
      enabled = "true"
      storage_uri = "${azurerm_storage_account.demo.primary_blob_endpoint}"
  }
}