resource "aws_vpc" "vpc_main" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge({ Name = "${var.name}-tf-vpc" }, var.tags)
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.az_public[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                = "${var.name}-tf-public-subnet-${count.index + 1}"
    Tier                                = "public"
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.az_private[count.index]

  tags = {
    Name                                = "${var.name}-tf-private-subnet-${count.index + 1}"
    Tier                                = "private"
    "kubernetes.io/cluster/${var.name}" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.name}-tf-gw"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_main.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat_gw[0].id
    }
  }

  tags = {
    Name = "${var.name}-tf-private-rt"
  }
}

resource "aws_default_route_table" "default_public_rt" {
  default_route_table_id = aws_vpc.vpc_main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.name}-tf-public-rt"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc_main.default_network_acl_id
  subnet_ids             = aws_subnet.public_subnet.*.id
  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }
  tags = {
    Name = "${var.name}-tf-public-nacl"
  }
}

resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.vpc_main.id
  subnet_ids = aws_subnet.private_subnet.*.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = {
    Name = "${var.name}-tf-private-nacl"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_default_route_table.default_public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gateway ? 1 : 0
  tags = {
    Name = "${var.name}-tf-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${var.name}-tf-nat-gw"
  }
}

resource "aws_security_group" "vpc_sg" {
  name        = "${var.name}-tf-vpc-all-allowed-sg"
  description = "Allow all ports, #TODO refine it later"
  vpc_id      = aws_vpc.vpc_main.id

  ingress {
    description = "Allowing all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.name}-tf-vpc-all-allowed-sg"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  count             = var.enable_ec2_vpc_endpoint ? 1 : 0
  vpc_id            = aws_vpc.vpc_main.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.ec2"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    aws_security_group.vpc_sg.id
  ]
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private_subnet.*.id
  tags = {
    "Name" = "${var.name}-ec2-enpoint"
  }
}
