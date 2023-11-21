module "sui" {
  source         = "Crouton-Digital/sui-node/aws"
  version        = "0.1.0" # Set last module version
  #source         = "../../"

  aws_region            = "eu-west-2"
  aws_availability_zone = "eu-west-2a"
  aws_image_name        = "debian-11-amd64*"
  aws_instance_type     = "t2.medium"
  vpc_name              = "sui-node"
  ssh_key_name          = "sui-node-key"
  sui_network           = "mainnet"
  app_version           = "mainnet"
  storage_persistent_data = "10"
}

output "node_host_ip" {
  value = module.sui.host_ip
}