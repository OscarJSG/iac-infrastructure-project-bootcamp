resource "aws_vpc" "vpc_project" {
  cidr_block           = "10.0.0.0/16" # Rango de direcciones IP para la VPC
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_project"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = "10.0.1.0/24" # Rango de direcciones IP para la subred pública
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = "10.0.2.0/24" # Rango de direcciones IP para la subred privada
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_project.id
  cidr_block        = "10.0.3.0/24" # Rango de direcciones IP para la segunda subred privada
  availability_zone = "us-east-1b"  # Zona de disponibilidad diferente
  tags = {
    Name = "private_subnet_2"
  }
}


resource "aws_internet_gateway" "gw_project" {
  vpc_id = aws_vpc.vpc_project.id

  tags = {
    Name = "gw_project"
  }
}

resource "aws_route_table" "rt_project" {
  vpc_id = aws_vpc.vpc_project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_project.id
  }

  tags = {
    Name = "rt_project"
  }

}

resource "aws_route_table_association" "a_rt_project_public_subnet" { # se utiliza para asociar una tabla de rutas (route table) a una subred en una VPC.
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_project.id

}
