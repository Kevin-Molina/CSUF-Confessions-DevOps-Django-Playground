terraform {
  backend "s3" {
    bucket = "confessions-terraform-state"
    key    = "vpc-us-east-1.tfstate"
  }
}

provider "aws" {
    profile = "default"
    version = "~> 2.66"
}

resource "aws_vpc" "vpc_us_east_1" {
    cidr_block       = "10.0.0.0/16"
}

// Public Subnets
resource "aws_subnet" "public_subnet_us_east_1a" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.0.0/22"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Type = "Public Subnet"
    }
}

resource "aws_subnet" "public_subnet_us_east_1b" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.4.0/22"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Type = "Public Subnet"
    }
}

resource "aws_subnet" "public_subnet_us_east_1c" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.8.0/22"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true

    tags = {
        Type = "Public Subnet"
    }
}

// Private Subnets
resource "aws_subnet" "private_subnet_us_east_1a" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.12.0/22"
    availability_zone = "us-east-1a"

    tags = {
        Type = "Private Subnet"
    }
}

resource "aws_subnet" "private_subnet_us_east_1b" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.16.0/22"
    availability_zone = "us-east-1b"

    tags = {
        Type = "Private Subnet"
    }
}

resource "aws_subnet" "private_subnet_us_east_1c" {
    vpc_id            = aws_vpc.vpc_us_east_1.id
    cidr_block        = "10.0.20.0/22"
    availability_zone = "us-east-1c"

    tags = {
        Type = "Private Subnet"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_us_east_1.id
}

resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.vpc_us_east_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "Custom Route table"
  }
}

resource "aws_route_table_association" "subnet_east_1a_association" {
  subnet_id      = aws_subnet.public_subnet_us_east_1a.id
  route_table_id = aws_route_table.custom_route_table.id
}

resource "aws_route_table_association" "subnet_east_1b_association" {
  subnet_id      = aws_subnet.public_subnet_us_east_1b.id
  route_table_id = aws_route_table.custom_route_table.id
}

resource "aws_route_table_association" "subnet_east_1c_association" {
  subnet_id      = aws_subnet.public_subnet_us_east_1c.id
  route_table_id = aws_route_table.custom_route_table.id
}
