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
    cidr_block       = "10.0.0.0/20"
}

resource "aws_subnet" "subnet-us-east-1a" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.0.0/22"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet-us-east-1b" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.4.0/22"
    availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet-us-east-1c" {
    vpc_id            = aws_vpc.vpc-us-east-1.id
    cidr_block        = "10.0.8.0/22"
    availability_zone = "us-east-1c"
}
