locals {
  cluster-name = var.cluster-name
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr-block
  instance_tenancy = "defautlt"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    name = var.vpc-name
    env = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = var.igw-name
    env = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
  }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "pub_subnet" {
  count = var.pub-subnet-count
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pub-cidr-block,count.index)
  availability_zone = element(var.pub-availability-zone,count.index)
  map_customer_owned_ip_on_launch = true
  tags = {
    name = "${var.pub-sub-name}-${count.index+1}"
    env = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_subnet" "pri_subnet" {
  count = var.pri-subnet-count
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.pri-cidr-block,count.index)
  availability_zone = element(var.pri-availability-zone,count.index)
  map_customer_owned_ip_on_launch = true
  tags = {
    name = "${var.pri-sub-name}-${count.index+1}"
    env = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
  depends_on = [ aws_vpc.vpc ]
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = var.public-rt-name
    env = var.env
  }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_route_table_association" "pub_rt_assoc" {
  count = 3
  subnet_id = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
  depends_on = [ aws_vpc.vpc,aws_subnet.pub_subnet ]
}

resource "aws_eip" "ngw-eip" {
  domain = "vpc"
  tags = {
    name = var.eip-name
  }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id = aws_subnet.pub_subnet[0].id
  tags = {
    name = var.ngw-name
  }
  depends_on = [ aws_vpc.vpc,aws_eip.ngw-eip ]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    name = var.private-rt-name
    env = var.env
  }
  depends_on = [ aws_vpc.vpc ]
}

resource "aws_route_table_association" "prt_rt_assoc" {
  count = 3
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.pri_subnet[count.index].id
  depends_on = [ aws_vpc.vpc,aws_subnet.pri_subnet ]
}

resource "aws_security_group" "eks_cluster_sg" {
  name = var.eks-sg
  description = "acces on port 443 only for k8s cluster"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = var.eks-sg
  }
}