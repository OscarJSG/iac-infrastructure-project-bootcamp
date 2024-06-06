resource "aws_db_instance" "proyecto_rds" {
  allocated_storage      = 20 # 20 GB de almacenamiento gratuito
  storage_type           = "gp2"
  engine                 = "mysql"       # Puedes elegir MySQL, MariaDB, PostgreSQL o SQL Server Express Edition
  engine_version         = "5.7"         # Versión del motor de base de datos
  instance_class         = "db.t3.micro" # Tipo de instancia gratuita
  db_name                = "proyecto_db" # Nombre de la base de datos
  username               = "proyecto_user"
  password               = "admin1234" # Cambia esto por una contraseña segura
  db_subnet_group_name   = aws_db_subnet_group.proyecto_subnet_group.name
  vpc_security_group_ids = [aws_security_group.proyecto_sg.id]
  skip_final_snapshot    = true # No crear un snapshot al eliminar la instancia
}

resource "aws_security_group" "proyecto_sg" {
  name        = "proyecto_sg"
  description = "Grupo de seguridad para la instancia RDS"
  vpc_id      = aws_vpc.vpc_project.id

  ingress {
    from_port   = 3306 # Puerto MySQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block] # Permite el acceso desde la subred pública
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_subnet_group" "proyecto_subnet_group" {
  name        = "proyecto_subnet_group"
  description = "Grupo de subredes para la instancia RDS"
  subnet_ids  = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_2.id]
}
