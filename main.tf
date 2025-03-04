
# Creates the Resource Group for our entire project
resource "azurerm_resource_group" "linux_vm_rg" {
    name = var.rg # name of the resource azurerm_resource_group
    location = var.loc # Azure region where it will be deployed
}

# Creates the Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name = var.vnet
    location = var.loc
    resource_group_name = var.rg
    address_space = ["10.1.0.0/16"]

    depends_on = [azurerm_resource_group.linux_vm_rg]

}
    
# Creates the default subnet
resource "azurerm_subnet" "subnet1" {
    name = var.subnet1
    resource_group_name = var.rg
    virtual_network_name = var.vnet
    address_prefixes = ["10.1.0.0/24"]

    depends_on = [azurerm_virtual_network.vnet]
}


# Creates the Public IP for our resources

resource "azurerm_public_ip" "lvmpip" {
    name = var.lvmpip
    resource_group_name = var.rg
    location = var.loc
    allocation_method = "Static"

    depends_on = [azurerm_resource_group.linux_vm_rg]
}



# Creates the Network Security Group

resource "azurerm_network_security_group" "nsg" {
    name = var.nsg
    location = var.loc
    resource_group_name = var.rg

    depends_on = [azurerm_resource_group.linux_vm_rg]

    security_rule {
        name = "myNSGRuleHTTP"
        priority = 200
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name = "myNSGRuleSSH"
        priority = 205
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

# Creates the Network Interfaces (NIC) for the VM

resource "azurerm_network_interface" "nic1" {
    name = var.nic1
    location = var.loc
    resource_group_name = var.rg

    ip_configuration {
        name = "ipconfig1"
        subnet_id = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
    }
}



# Associates the NICs to the Network Security Group (NIC)

resource "azurerm_network_interface_security_group_association" "nsg_assoc_1" {
    network_interface_id = azurerm_network_interface.nic1.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}



# Creates the virtual machine
resource "azurerm_linux_virtual_machine" "vm1" {
    name = var.vm1
    location = var.loc
    resource_group_name = var.rg
    admin_username = "adminuser"
    admin_password = "GetMoneyWithCloud1~"
    network_interface_ids = [azurerm_network_interface.nic1.id]
    size = "Standard_B1s"
    zone = "3"

    admin_ssh_key {
        username = "adminuser"
        public_key = file("${path.module}/my_terraform_key.pub")
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "ubuntu-24_04-lts"
        sku = "server"
        version = "latest"
    }

    custom_data = filebase64("${path.module}/cloud-init.yml") # Load Cloud-Init script


    depends_on = [azurerm_network_interface.nic1]

}


