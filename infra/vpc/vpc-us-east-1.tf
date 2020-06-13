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

resource "aws_vpc" "vpc-us-east-1" {
    cidr_block       = "10.0.0.0/16"
}

// Public Subnets
resource "aws_subnet" "public-subnet-us-east-1a" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.0.0/22"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "public-subnet-us-east-1b" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.4.0/22"
    availability_zone = "us-east-1b"

    tags = {
        Type = "Public Subnet"
    }
}

resource "aws_subnet" "public-subnet-us-east-1c" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.8.0/22"
    availability_zone = "us-east-1c"

    tags = {
        Type = "Public Subnet"
    }
}

// Private Subnets
resource "aws_subnet" "private-subnet-us-east-1a" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.12.0/22"
    availability_zone = "us-east-1a"

    tags = {
        Type = "Private Subnet"
    }
}

resource "aws_subnet" "private-subnet-us-east-1b" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.16.0/22"
    availability_zone = "us-east-1b"

    tags = {
        Type = "Private Subnet"
    }
}

resource "aws_subnet" "private-subnet-us-east-1c" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.20.0/22"
    availability_zone = "us-east-1c"

    tags = {
        Type = "Private Subnet"
    }
}