-------------------------------child module--------------------------
#create subnet
resource "aws_subnet" "main" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.vpc-name}-subnett"
  }
}
#create IGW for public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc-name}-igww"
  }
}
#create RT
resource "aws_default_route_table" "main" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc-name}-igww"
  }
}
#create RT association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_default_route_table.main.id
}
