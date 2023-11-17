# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_eip" "ip_ip_env" {
  instance = aws_instance.my_instance.id
  domain   = "vpc"
}

resource "aws_internet_gateway" "vpc_gw" {
  vpc_id = aws_vpc.my_vpc.id

}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc_gw.id}"
  }

}
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.aws_availability_zone # Set your desired availability zone

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_security_group" "allow_all" {
  name = "${var.vpc_name}-allow-all-sg"
  vpc_id = "${aws_vpc.my_vpc.id}"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_debian_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [ var.aws_image_name ]
  }
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "my_instance" {
  ami                    = data.aws_ami.latest_debian_linux.id
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = templatefile("${path.module}/cloud_init.yml.tftpl", {
    opt                  = ""
    version              = var.app_version
    sui_network          = var.sui_network
  })
  key_name               = var.ssh_key_name # Update with your key pair name

  vpc_security_group_ids = [aws_security_group.allow_all.id]

#  lifecycle {
#    replace_triggered_by = [
#      user_data,
#      key_name
#    ]
#  }

  tags = {
    Name = "${var.vpc_name}"
  }
}

output "host_ip" {
  value = aws_eip.ip_ip_env.public_ip
}