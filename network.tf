
resource "aws_vpc" "application_vpc" {

  cidr_block = "10.0.0.0/16"


}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.application_vpc.id

}

data "aws_availability_zones" "available" {

}

resource "aws_subnet" "public_subnets" {
  count  = length(var.public_cidrs)
  vpc_id = aws_vpc.application_vpc.id

  cidr_block              = element(var.public_cidrs, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }



}

resource "aws_subnet" "private_subnets" {

  count      = length(var.private_cidrs)
  vpc_id     = aws_vpc.application_vpc.id
  cidr_block = element(var.private_cidrs, count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }

}

resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.application_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
  tags = {
    "Name" = "Public Route Table"
  }
}

resource "aws_route_table_association" "pub_assoc" {

  count          = length(var.public_cidrs)
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)


}