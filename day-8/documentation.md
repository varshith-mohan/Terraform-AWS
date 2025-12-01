# Meta-arguments
In Terraform, meta-arguments are special arguments that you can use inside any resource, module, or data block. They are not specific to a particular provider or resource type-they work universally across Terraform configuration.

We have the following meta-arguments:
count, for_each : Create or manage multiple resources <br>
depends_on: Enforce creation order <br>
lifecycle: Add custom behavior rules <br>
Provider : Use different provider configs<br>







# Terraform count Argument

* The count meta-argument is used to create multiple similar resources using a single resource block.
* Helps reduce code repetition and simplify configurations.
* You can reference each instance using its index value (count.index).
* Cannot create resources with different configurations -use 'for_each' instead for that.

~~~
provider "aws" {
  region = "ap-south-2" 
}

resource "aws_instance" "one" {   # aws_instance is resource type, "one"  local name used inside Terraform
  count = 3                       # Creates 3 identical EC2 instances
  ami   = "ami-046d18c147c36bef1" # Specifies OS image of EC2 instance [ec2 -> AMI catalog -> find ami ID]
  instance_type = "t2.micro"       # t2.micro is low-cost, free-tier-eligible

  tags = {
    Name = "MyInstance-${count.index}" # Gives each instance a unique name : MyInstance-0, MyInstance-1, 2
  }
}
~~~

When you run: terraform apply <br>

Terraform will: Connect to AWS -> Launch 3 EC2 instances -> Assign unique names -> Store state file locally

***

# Terraform for_each Argument

* For_each is a loop used to create multiple resources from a single resource block.
* Unlike count, it allows different configurations or unique identifiers per resource.
* Helps reduce repetitive code while maintaining flexibility.
* Each item in the list or map is assigned a unique key (cach.key).
* Ideal for creating resources like ECz instances, S3 buckets, or subnets with different names.

**toset() converts a list into a set in Terraform. It enforces uniqueness and is commonly used with for_each to guarantee stable, unique resource creation keys and avoid accidental duplication**
~~~

provider "aws" {
  region = "ap-south-2"
}

resource "aws_instance" "one" {
  for_each = toset(["dev-server", "test-server", "prod-server"]) # Creates multiple instances using a list of names. eg aws_instance.one["dev-server"]

  ami           = "ami-046d45c147c36bef1"
  instance_type = "t2.micro"

  tags = {
    Name = each.key  # Each EC2 gets a name matching its environment: Instance	-> dev-server	| Tag -> dev-server
  }
}
~~~

***

# Terraform depends_on
* Used to manually define dependencies between resources.
* Ensures one resource is created or destroyed only after another resource is complete.
* Normally Terraform detects dependencies automatically, but depends_op helps when relationships aren't direct.

~~~
provider "aws" {
  region = "ap-south-2"
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-03695d52f0d883f65"
  instance_type = "t3.micro"

  tags = {
    Name = "My-Depends-Instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "s3-new-bucket" {
  bucket = "day8-demo-bucket"

  depends_on = [
    aws_instance.ec2_instance
  ]
}
~~~

















