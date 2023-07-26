variable "associate_public_ip" {
  default = true
}
variable "public_key" {}
variable "image" {}
variable "disk" {}
variable "instance_type" {}
variable "volume_encrypted" {
  default = true
}
variable "volume_delete_on_termination" {
  default = true
}
variable "name" {}
variable "subnet" {}
variable "vpc_security_group_id" {}
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "tag_provisioner" {
  default = "terraform"
}
variable "tag_owner" {
  default = "hobbyfarm"
}
variable "volume_type" {
  default = "gp3"
}

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
  associate_public_ip_address = var.associate_public_ip
  tags = {
    Name        = "${var.name}"
    Owner       = "${var.tag_owner}"
    provisioner = "${var.tag_provisioner}"
  }
  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = var.disk
    encrypted             = var.volume_encrypted
    delete_on_termination = var.volume_delete_on_termination
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
