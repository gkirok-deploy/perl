resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "test-vpc"
  }
}

## Define the public subnet
resource "aws_subnet" "public-subnet-a" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet-a" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_a_cidr}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "private subnet a"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet-b" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_b_cidr}"
  availability_zone = "${var.aws_region}b"

  tags {
    Name = "private subnet b"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet-c" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_c_cidr}"
  availability_zone = "${var.aws_region}c"

  tags {
    Name = "private subnet c"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Define the route table
resource "aws_route_table" "web-private-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "172.0.0.0/8"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  route {
    cidr_block = "10.0.0.0/8"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "private subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet-a.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-private-rt" {
  subnet_id = "${aws_subnet.private-subnet-a.id}"
  route_table_id = "${aws_route_table.web-private-rt.id}"
}
