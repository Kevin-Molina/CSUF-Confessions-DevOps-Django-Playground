data "terraform_remote_state" "subnet_group" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "vpc-us-east-1.tfstate"
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config = {
    bucket = "confessions-terraform-state"
    key = "security-groups.tfstate"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1a, 
                data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1b, 
                data.terraform_remote_state.subnet_group.outputs.private_subnet_us_east_1c]

  tags = {
    Name = "DB subnet group"
  }
}


resource "aws_db_instance" "db_instance" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgresql"
  engine_version          = "11.7"
  instance_class          = "db.t2.micro"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [data.terraform_remote_state.security_group.outputs.db_sg_id]
  name                    = "confessions"
  identifier              = "confession-db"
  multi_az                = false
  username                = "master"
  backup_retention_period = 7
}