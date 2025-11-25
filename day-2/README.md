# Day 2: Terraform Provider

## Topics Covered
- Terraform Providers
- Provider version vs Terraform core version
- Why version matters
- Version constraints
- Operators for versions

## Key Learning Points

### What are Terraform Providers?
Providers are plugins that allow Terraform to interact with cloud platforms, SaaS providers, and other APIs. For AWS, we use the `hashicorp/aws` provider.

### Provider vs Terraform Core Version
- **Terraform Core**: The main Terraform binary that parses configuration and manages state
- **Provider Version**: Individual plugins that communicate with specific APIs (AWS, Azure, Google Cloud, etc.)
- They have independent versioning and release cycles

### Why Version Matters
- **Compatibility**: Ensure provider works with your Terraform version
- **Stability**: Pin to specific versions to avoid breaking changes
- **Features**: New provider versions add support for new AWS services
- **Bug Fixes**: Updates often include important security and bug fixes
- **Reproducibility**: Same versions ensure consistent behavior across environments

### Version Constraints
Use version constraints to specify acceptable provider versions:

- `= 1.2.3` - Exact version
- `>= 1.2` - Greater than or equal to
- `<= 1.2` - Less than or equal to
- `~> 1.2` - Pessimistic constraint (allow patch releases)
- `>= 1.2, < 2.0` - Range constraint

### Best Practices
1. Always specify provider versions
2. Use pessimistic constraints for stability
3. Test provider upgrades in development first
4. Document version requirements in your README
5. Use terraform providers lock command for consistency

## Configuration Examples

### Basic Provider Configuration
```hcl

# 1) Tell Terraform which providers and versions are required
terraform {
  required_providers {
    aws = {                     # "source" specifies the registry namespace and provider name,
      source  = "hashicorp/aws" # "hashicorp/aws" means the official AWS provider published by HashiCorp.
      version = "~> 6.0"        # any version >= 6.0.0 and < 7.0.0
    }
  }
}


# 2) Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # AWS region where resources will be created
}

# 3) Declare a resource (the actual infra you want Terraform to manage) 
# Creating a Virtual Private Cloud (VPC) 
# VPC is a logically isolated, private network within a public cloud 
# where you can launch your cloud resources
# resource is a key word 
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16" # The CIDR block defines the private IPv4 address range for the VPC.
}                           # "10.0.0.0/16" gives you 65,536 addresses for subnets inside this VPC

```

### Multiple Provider Versions
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
```


### commands & lifecycle
```hcl
# ─────────────────────────────────────────────────────────────────
# Usage Notes
# ─────────────────────────────────────────────────────────────────

# 1. terraform init
#    - Downloads the provider binary from the Registry (hashicorp/aws@~>6.0),
#    - Initializes backend & modules.
#
# 2. terraform plan
#    - Shows the execution plan: what Terraform will create/change/destroy.
#
# 3. terraform apply
#    - Applies the plan and makes API calls to the target (AWS) via the provider plugin.
#
# 4. terraform destroy
#    - Tears down resources managed by the configuration.
```



