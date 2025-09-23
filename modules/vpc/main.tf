resource "aws_vpc" "homelab" {
  cidr_block = var.cidr_block

  tags = {
    Name = "homelab-vpc"
  }
}

# -----------------------------
# Public Subnets
# -----------------------------
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }

  vpc_id                  = aws_vpc.homelab.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = var.azs[tonumber(each.key)]

  tags = {
    Name = "homelab-public-${each.key}"
  }
}

# -----------------------------
# Private Subnets
# -----------------------------
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }

  vpc_id                  = aws_vpc.homelab.id
  cidr_block              = each.value
  map_public_ip_on_launch = false
  availability_zone       = var.azs[tonumber(each.key)]

  tags = {
    Name = "homelab-private-${each.key}"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.homelab.id

  tags = {
    Name = "homelab-igw"
  }
}

# -----------------------------
# NAT Gateway (Single)
# -----------------------------
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "homelab-natgw"
  }
}

# Elastic IP untuk NAT Gateway (baru dibuat otomatis)
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "homelab-nat-eip"
  }
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.homelab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "homelab-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------
# Private Route Table
# -----------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.homelab.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "homelab-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
