resource "aws_security_group" "public" {
  name   = "${var.system_name}-${var.env}-public-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.system_name}-${var.env}-public-sg"
    }
  )
}

resource "aws_security_group" "private" {
  name   = "${var.system_name}-${var.env}-private-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.system_name}-${var.env}-private-sg"
    }
  )
}

resource "aws_security_group" "efs" {
  name   = "${var.system_name}-${var.env}-efs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "SSH"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id, aws_security_group.private.id]
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.system_name}-${var.env}-efs-sg"
    }
  )
}
