variable "aws_region" {
  default = "eu-west-2"
  description = "AWS region"
}

variable "aws_availability_zone" {
  default = "eu-west-2a"
  description = "AWS region"
}

variable "aws_image_name" {
  description = "The AMI IMAGE NAME for the EC2 instance"
  default     = "debian-11-amd64*"  # Update with the desired AMI
}

variable "ssh_key_name" {
  description = "The name of the key pair for the EC2 instance"
  default     = ""  # Update with your key pair name
}

variable "vpc_name" {
  default     = "sui-node"
  description = "vpc name prefix"
}

variable "aws_instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "storage_persistent_data" {
  default     = "10"
  description = "Storage for persistent data"
}

# Version docker containers
variable "app_version" {
  default = "testnet"
  description = "Docker app version"
}

variable "sui_network" {
  default = "testnet"
  description = "SUI network mainnet / testnet / devnet "
}