resource "aws_db_subnet_group" "db_subnet_grp" {
  name       = "polling-prod-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "polling-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {

  allocated_storage     = 20
  max_allocated_storage = 22
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"

  db_name  = "polls"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_grp.name
  vpc_security_group_ids = var.db_sg_id


  multi_az            = false
  skip_final_snapshot = true

  tags = {
    Name = "polling-lowcost-mysql"
  }


}
