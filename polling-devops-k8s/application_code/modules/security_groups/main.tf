resource "aws_security_group" "alb_sg" {
  name        = "polling-alb-sg"
  description = "Allow public HTTP traffic to ALB"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "polling-alb-sg" }
}


resource "aws_security_group" "ecs_sg" {
  name        = "polling-ecs-sg"
  description = "Allow traffic only from the ALB"
  vpc_id      = var.vpc_id


  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "polling-ecs-sg" }
}


resource "aws_security_group" "db_sg" {
  name        = "polling-db-sg"
  description = "Allow MySQL traffic only from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "polling-db-sg" }
}
