
# Resource Group variable 
variable "rg" {
    description = "The name of the Azure Resource Group"
    type = string
    default = "EVLinuxVMAutomation5917"
}

# Location variable
variable "loc" {
    description = "The location where we're deploying all of our resources"
    type = string
    default = "East US"
}

# Virtual Network variable
variable "vnet" {
    description = "The name of the Virtual Network for our project."
    type = string
    default = "myVNet"
}

# Default Subnet variable
variable "subnet1" {
    description = "The name of the subnet for our Azure Linux VM."
    type =  string
    default = "subnet1"
}


# Linux VM Public IP name variable
variable "lvmpip" {
    description = "The name of the Azure VM's public IP address"
    type = string
    default = "myPublicIP"
}


# Network Security Group name variable
variable "nsg" {
    description = "The name of the network security group"
    type = string
    default = "myNSG"
}



# Network Interface 1 name variable
variable "nic1" {
    description = "The name of virtual machine 1's NIC"
    type = string
    default = "myNicVM1"
}



# Virtual Machine 1 name variable
variable "vm1" {
    description = "The name of virtual machine 1"
    type = string
    default = "myLinuxVM1"
}

