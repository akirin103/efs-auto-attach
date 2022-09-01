locals {
  public_key_path = "~/.ssh/id_rsa.pub"
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module "public" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.0.0"
  name                        = "${var.system_name}-${var.env}-public"
  ami                         = data.aws_ssm_parameter.this.value
  instance_type               = var.instance_type
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  user_data                   = data.template_file.init.rendered
  tags                        = local.tags
  depends_on = [
    aws_efs_file_system.this,
    aws_efs_mount_target.this,
  ]
}

module "private" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "4.0.0"
  name                        = "${var.system_name}-${var.env}-private"
  ami                         = data.aws_ssm_parameter.this.value
  instance_type               = var.instance_type
  subnet_id                   = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.private.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.this.key_name
  user_data                   = data.template_file.init.rendered
  tags                        = local.tags
  depends_on = [
    aws_efs_file_system.this,
    aws_efs_mount_target.this,
  ]
}

resource "aws_key_pair" "this" {
  key_name   = "${var.system_name}-${var.env}-key-pair"
  public_key = file(local.public_key_path)
  tags       = local.tags
}

data "template_file" "init" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    efs_id = aws_efs_file_system.this.id
  }
}
