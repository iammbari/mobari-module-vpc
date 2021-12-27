variable "name" {
    type = string
    description = "Friendly Name value for the VPC and Subnetwork components"
}
variable "env" {
    type = string
    description = "Friendly Environment value for the VPC and Subnetwork components"
}
variable "ou"  {
    type = string
    description = "Friendly OU value for the VPC components"
}
variable "managedby"                                    {
    type = string
    default = "MoJ-TechOps"
    description = "Tagging value for identifying resposible party for resources"
}                                         
variable "enable_dns_support" {
    type = bool
    default = true
    description = "Boolean value on whether to enable EC2 DNS Support within the VPN"
                                                        }
variable "enable_dns_hostnames"                         {
    type = bool
    default = true
    description = "Boolean value on whether to enable EC2 DNS hostnames within the VPN"
}
variable "vpc_cidr_block"   {
    type = string
    description = "CIDR block to be assigned to the VPC Network"
}
variable "primary_subnet_cidr"  {
    type = list(string)
    default = []
    description = "CIDR block(s) in list format to be assigned to the VPC Primary (1) tier of Subnetwork(s)"
}
variable "secondary_subnet_cidr"{
    type = list(string)
    default = []
    description = "CIDR block(s) in list format to be assigned to the VPC Secondary (2) tier of Subnetwork(s)"
}
variable "tertiary_subnet_cidr" {
    type = list(string)
    default = []
    description = "CIDR block(s) in list format to be assigned to the VPC Tertiary (3) tier of Subnetwork(s)"
}


variable "availability_zones" {
    type        = list
    default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
    description = "Availability Zones to be used by subnets created within this module"
}

variable "public_rt_name"{
    default = null
    type = string
    description = "Name value for Public Route Table"
}
variable "private_rt_name" {
    default = null
    type = string
    description = "Name value for Private Route Table"
}
variable "primary_subnet_name" {
    default = null
    type = string
    description = "Name value for primary subnets"
}
variable "secondary_subnet_name"{
    default = null
    type = string
    description = "Name value for secondary subnets"
}
variable "tertiary_subnet_name" {
    default = null
    type = string
    description = "Name value for tertiary subnets"
}
