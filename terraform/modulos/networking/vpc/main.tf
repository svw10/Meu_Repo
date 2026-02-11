resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr; enable_dns_hostnames = true; enable_dns_support = true
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-vpc" })
}
resource "aws_internet_gateway" "this" { vpc_id = aws_vpc.this.id; tags = merge(var.tags, { Name = "${var.project_name}-igw" }) }

resource "aws_subnet" "public" {
  count = length(var.availability_zones); vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index); availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, { Name = "${var.project_name}-public-${var.availability_zones[count.index]}"; Tier = "Public" })
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones); vpc_id = aws_vpc.this.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + 10); availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, { Name = "${var.project_name}-private-${var.availability_zones[count.index]}"; Tier = "Private" })
}

resource "aws_eip" "nat" { count = var.enable_nat_gateway ? 1 : 0; domain = "vpc"; tags = var.tags }
resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0; allocation_id = aws_eip.nat[0].id; subnet_id = aws_subnet.public[0].id
  tags = merge(var.tags, { Name = "${var.project_name}-nat" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route { cidr_block = "0.0.0.0/0"; gateway_id = aws_internet_gateway.this.id }
  tags = merge(var.tags, { Name = "public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content { cidr_block = "0.0.0.0/0"; nat_gateway_id = aws_nat_gateway.this[0].id }
  }
  tags = merge(var.tags, { Name = "private-rt" })
}

resource "aws_route_table_association" "public" { count = length(aws_subnet.public); subnet_id = aws_subnet.public[count.index].id; route_table_id = aws_route_table.public.id }
resource "aws_route_table_association" "private" { count = length(aws_subnet.private); subnet_id = aws_subnet.private[count.index].id; route_table_id = aws_route_table.private.id }

resource "aws_security_group" "default_vpc_sg" {
  name = "${var.project_name}-default-sg"; vpc_id = aws_vpc.this.id
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = var.tags
}
