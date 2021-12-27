locals {
    common_tags = {
        Terraform       = "true"
        Managed_By      = var.managedby
    }
}


data "aws_caller_identity" "current" {}