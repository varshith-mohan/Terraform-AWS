# 1. Variables.tf <br>
Defines input variables for your Terraform configuration <br>
Specifies data types, descriptions, and default values <br>

Content to Keep: <br>
All input parameters that can be customized <br>
Type constraints for validation <br>
Sensitive data (with sensitive = true) <br>
Environment-specific defaults <br>

~~~
# String type
variable "environment" {
  type        = string
  description = "The environment type"
  default     = "dev"
}

# Object type
variable "server_config" {
  type = object({
    name           = string
    instance_type  = string
    monitoring     = bool
    storage_gb     = number
    backup_enabled = bool
  })
}
~~~

Connections: <br>
Variables are referenced throughout other files using var.<variable_name> <br>
Used in main.tf, locals.tf, provider.tf, and outputs.tf <br>

# 2. locals.tf  <br>
Defines local values (computed values that can be reused) <br>
Performs data transformations and calculations <br>

Content to Keep: <br>
Derived values from variables <br>
Common tags or labels <br>
Computed values (concatenations, transformations) <br>
Reusable constants<br>

~~~
locals {
  # Common tags
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
  
  # Computed values
  instance_name = "${var.environment}-instance"
}
~~~~

Connections:<br>
Locals are referenced using local.<local_name><br>
Used to simplify complex expressions in main.tf and outputs.tf<br>

# 3. provider.tf <br>

Configures the cloud provider (AWS in this case)<br>
Specifies Terraform version requirements<br>

Content to Keep:<br>
Provider configuration (region, credentials, settings)<br>
Terraform version constraints<br>
Backend configuration for state storage<br>
Required provider versions<br>

~~~
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }
}

provider "aws" {
  region = var.region
}
~~~

Connections:<br>
Providers enable communication with cloud services<br>
Resources in main.tf depend on provider configuration<br>
Uses variables from variables.tf<br>

# 4. main.tf

Contains the main infrastructure resources<br>
Defines actual cloud resources to be created<br>

Content to Keep:<br>
Resource declarations (EC2, VPC, S3, etc.)<br>
Resource dependencies and relationships<br>
Resource-specific configurations<br>

~~~
resource "aws_instance" "web_server" {
  ami           = "ami-12345"
  instance_type = var.instance_type
  count         = var.instance_count
  
  tags = var.instance_tags
}
~~~

Connections:<br>
References variables from variables.tf<br>
Uses locals from locals.tf<br>
Resources are referenced in outputs.tf<br>
Depends on provider configuration<br>

# 5. outputs.tf

Defines output values to display after terraform apply <br>
Exports information about created resources<br>

Content to Keep:<br>
Important resource attributes (IDs, IPs, URLs)<br>
Computed values useful for other systems<br>
Debugging information<br>

~~~
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address"
  value       = aws_instance.web_server.public_ip
}
~~~

Connections:<br>
References resources from main.tf<br>
References variables and locals<br>
Outputs are displayed after terraform apply<br>

<br>

# Dependency Flow

~~~
1. Start with variables.tf to define inputs
2. Configure provider.tf for cloud access
3. Create locals.tf for complex computations
4. Build resources in main.tf using variables and locals
5. Define outputs in outputs.tf to display required only important data
~~~

<br>

A simple mental diagram for your setup:  <br>
~~~
                 +----------------+
                 |  variables.tf  |
                 |  (var.*)       |
                 +--------+-------+
                          |
                          v
                 +----------------+
                 |   locals.tf    |
                 |  (local.*)     |
                 +--+----------+--+
                    |          |
   +----------------+          +----------------+
   v                                           v
+----------+                         +----------------+
|provider  |                         |    main.tf     |
|provider.tf                         | (resources)    |
| (aws)    |------------------------>| uses var.*,    |
+----------+                         | local.*, aws   |
                                     +--------+-------+
                                              |
                                              v
                                     +----------------+
                                     |   outputs.tf   |
                                     |  (output.*)    |
                                     +----------------+

~~~

















































