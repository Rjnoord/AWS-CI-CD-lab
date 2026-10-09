resource "aws_vpc" "rjnoord-aws-practice-lab-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "rjnoord-2"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id            = var.vpc
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "rjnoord-subnet-public-2"
  }
}

resource "aws_subnet" "private-subnet-a" {
  vpc_id            = var.vpc
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  tags = {
    Name = "rjnoord-subnet-private-2"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id            = var.vpc
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "rjnoord-subnet-public-3"
  }
}


resource "aws_subnet" "private-subnet-b" {
  vpc_id            = var.vpc
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = "rjnoord-subnet-private-3"
  }
}

resource "aws_internet_gateway" "rjnoord-igw" {
  vpc_id = var.vpc
  tags = {
    Name = "rjnoord-igw-2"
  }
}

resource "aws_eip" "rjnoord-eip-a" {
  domain = "vpc"
  tags = {
    Name = "rjnoord-eip-a"
  }
}

resource "aws_eip" "rjnoord-eip-b" {
  domain = "vpc"
  tags = {
    Name = "rjnoord-eip-b"
  }
}

resource "aws_nat_gateway" "rjnoord-nat-gw-a" {
  allocation_id = aws_eip.rjnoord-eip-a.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "rjnoord-nat-a"
  }
}

resource "aws_nat_gateway" "rjnoord-nat-gw-b" {
  allocation_id = aws_eip.rjnoord-eip-b.id
  subnet_id     = aws_subnet.public-subnet-b.id

  tags = {
    Name = "rjnoord-nat-gw-b"
  }
}

resource "aws_route_table" "rjnoord-public-rt-2" {
  vpc_id = aws_vpc.rjnoord-aws-practice-lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rjnoord-igw.id
  }
}

resource "aws_route_table_association" "rjnoord-public-rt-assoc-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.rjnoord-public-rt-2.id
}

resource "aws_route_table_association" "rjnoord-public-rt-assoc-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.rjnoord-public-rt-2.id
}

resource "aws_route_table" "rjnoord-private-rt-a" {
  vpc_id = aws_vpc.rjnoord-aws-practice-lab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rjnoord-nat-gw-a.id
  }
}

resource "aws_route_table" "rjnoord-private-rt-b" {
  vpc_id = aws_vpc.rjnoord-aws-practice-lab-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rjnoord-nat-gw-b.id
  }
}

resource "aws_route_table_association" "rjnoord-private-rt-assoc-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.rjnoord-private-rt-a.id
}

resource "aws_route_table_association" "rjnoord-private-rt-assoc-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.rjnoord-private-rt-b.id
}

resource "aws_security_group" "rjnoord-alb-sg" {
  name        = "rjnoord-alb-sg"
  description = "Security group for alb rjnoord-2"
  vpc_id      = aws_vpc.rjnoord-aws-practice-lab-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rjnoord-sg-2" {
  name        = "rjnoord-sg-2"
  description = "Security group for rjnoord-2"
  vpc_id      = var.vpc

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.rjnoord-alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "rjnoord-alb" {
  name                       = "rjnoord-alb"
  internal                   = false
  security_groups            = [aws_security_group.rjnoord-alb-sg.id]
  subnets                    = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "rjnoord-tg" {
  name     = "rjnoord-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.rjnoord-aws-practice-lab-vpc.id
}

resource "aws_lb_listener" "rjnoord-listener" {
  load_balancer_arn = aws_lb.rjnoord-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rjnoord-tg.arn
  }
}

resource "aws_instance" "rjnoord-ec2" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.large"
  subnet_id              = var.subnet_private_1a
  vpc_security_group_ids = [aws_security_group.rjnoord-sg-2.id]

  tags = {
    Name = "rjnoord-ec2"
  }

}

resource "aws_ecr_repository" "rjnoord-ecr" {
  name                 = "rjnoord-ecr-app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "rjnoord-ecr-app"
  }
}

resource "aws_ecs_cluster" "rjnoord_cluster" {
  name = "rjnoord-cluster"

  tags = {
    Environment = "lab"
  }
}

resource "aws_ecs_task_definition" "rjnoord-task-definition" {

  family                   = "rjnoord-ecr-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.rjnoord-ecs-task-role.arn
  execution_role_arn       = aws_iam_role.rjnoord-ecs-execution-role.arn

  container_definitions = jsonencode([
    {
      name      = "rjnoord-ecr-app"
      image     = "${aws_ecr_repository.rjnoord-ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "rjnoord-ecs-service" {
  name            = "rjnoord-ecs-service"
  cluster         = aws_ecs_cluster.rjnoord_cluster.id
  task_definition = aws_ecs_task_definition.rjnoord-task-definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.subnet_private_1a, var.subnet_private_1b]
    security_groups  = [aws_security_group.rjnoord-sg-2.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.rjnoord-tg.arn
    container_name   = "rjnoord-ecr-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.rjnoord-listener]
}

resource "aws_iam_role" "rjnoord-ecs-task-role" {
  name = "rjnoord-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

