variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "public_key" {}

variable "image" {}
variable "instance_type" {}
variable "subnet" {}
variable "vpc_security_group_id" {}

variable "disk" {}

variable "name" {}


provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_key_pair" "instance_keypair" {
  key_name   = "${var.name}-keypair"
  public_key = var.public_key
}

resource "aws_instance" "instance" {
  ami                         = var.image
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.instance_keypair.key_name
  subnet_id                   = var.subnet
  vpc_security_group_ids      = ["${var.vpc_security_group_id}"]
  associate_public_ip_address = true
  tags = {
    Name        = "${var.name}"
    Owner       = "hobbyfarm"
    provisioner = "terraform"
  }
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.disk
    encrypted             = true
    delete_on_termination = true
  }
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "hostname" {
  value = aws_instance.instance.public_dns
}
