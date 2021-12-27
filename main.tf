
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

tags = merge(
    local.common_tags,
    tomap({
        Name = "${var.name} VPC"
    })
)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
    tags = merge(
    local.common_tags, 
    tomap({
        Name = "${var.name}-IGW"
    })
  )
}

resource "aws_subnet" "primary" {
  
  count                   = length(var.primary_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.primary_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  //map_public_ip_on_launch = true
  
  tags = merge(
        local.common_tags,
        tomap({
            Name = "${var.primary_subnet_name}-az${count.index +1}"
            Availability_Zone = element(var.availability_zones, count.index)
        })
    )
}


resource "aws_eip" "nat" {
  //count = length(var.secondary_subnet_cidr) # use this if NGW required per AZs
  count = 1
  vpc   = true
  tags = merge(
    local.common_tags,
    tomap({
        Name = "${var.name}-EIP${count.index+1}"
    })
  )
}

resource "aws_nat_gateway" "main" {
  //count         = length(var.secondary_subnet_cidr) # use this if NGW required per AZs
  count         = 1
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.primary.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]
  tags = merge(
    local.common_tags,
    tomap({
        Name = "${var.name}-NGW${count.index+1}"
    })
  )
}


resource "aws_subnet" "secondary" {
  count             = length(var.secondary_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.secondary_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  
 tags = merge(
        local.common_tags,
        tomap({
            Name = "${var.secondary_subnet_name}-az${count.index +1}"
            Availability_Zone = element(var.availability_zones, count.index)
        })
    )
}

resource "aws_subnet" "tertiary" {
  count             = length(var.tertiary_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.tertiary_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)
  
 tags = merge(
        local.common_tags,
        tomap({
            Name = "${var.tertiary_subnet_name}-az${count.index +1}"
            Availability_Zone = element(var.availability_zones, count.index)
        })
    )
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    tomap({
        Name = "${var.public_rt_name}"
    })
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.primary_subnet_cidr)
  subnet_id      = element(aws_subnet.primary.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  //count  = length(var.secondary_subnet_cidr) # use this if Private Route Table required per AZs
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    tomap({
        Name = "${var.private_rt_name}"
    })
  )
}

resource "aws_route" "private" {
  count                  = 1
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "secondary" {
  count          = length(var.secondary_subnet_cidr)
  subnet_id      = element(aws_subnet.secondary.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "tertiary" {
  count          = length(var.tertiary_subnet_cidr)
  subnet_id      = element(aws_subnet.tertiary.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

