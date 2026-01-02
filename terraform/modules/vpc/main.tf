resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { 
    Name = "${var.name}-vpc" 
    }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { 
    Name = "${var.name}-igw" 
    }
}

# Public subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.azs)
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, index(var.azs, each.value))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${each.value}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  for_each          = toset(var.azs)
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, 8 + index(var.azs, each.value))

  tags = {
    Name = "${var.name}-private-${each.value}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-public-rt" }
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT (single or per-AZ)
resource "aws_eip" "nat" {
  count  = var.single_nat_gateway ? 1 : length(var.azs)
  domain = "vpc"
  tags   = { Name = "${var.name}-nat-eip-${count.index}" }
}

resource "aws_nat_gateway" "this" {
  count         = var.single_nat_gateway ? 1 : length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = values(aws_subnet.public)[var.single_nat_gateway ? 0 : count.index].id
  tags          = { Name = "${var.name}-nat-${count.index}" }
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(var.azs)
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name}-private-rt-${count.index}" }
}

resource "aws_route" "private_nat" {
  count                  = var.single_nat_gateway ? 1 : length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[count.index].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = var.single_nat_gateway ? aws_route_table.private[0].id : aws_route_table.private[index(var.azs, each.value.availability_zone)].id
}
