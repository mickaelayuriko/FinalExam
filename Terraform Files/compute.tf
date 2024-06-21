variable "production_instance_ids" {
  description = "List of IDs of production instances"
  type        = list(string)
  default     = []
}

resource "aws_instance" "production_1" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = aws_subnet.main_a.id

  tags = {
    Name = "Production_Env1"
  }

  vpc_security_group_ids = [aws_security_group.prod_sg.id]
}

resource "aws_instance" "production_2" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = aws_subnet.main_b.id

  tags = {
    Name = "Production_Env2"
  }

  vpc_security_group_ids = [aws_security_group.prod_sg.id]
}

resource "aws_instance" "jenkins" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.main_a.id

  tags = {
    Name = "JenkinsController"
  }

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum -y update
              sudo yum -y install nodejs
              sudo yum -y install npm
              sudo yum -y update
              sudo yum -y install java-21-amazon-corretto
              sudo yum -y install git
              sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum -y install jenkins
              sudo service jenkins start
              EOF
}

resource "aws_instance" "testing" {
  ami           = "ami-0440d3b780d96b29d" 
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = aws_subnet.main_a.id

  tags = {
    Name = "Testing_Env"
  }

  vpc_security_group_ids = [aws_security_group.default_sg.id]
}

resource "aws_instance" "staging" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name
  subnet_id     = aws_subnet.main_b.id

  tags = {
    Name = "Staging_Env"
  }

  vpc_security_group_ids = [aws_security_group.default_sg.id]
}

output "production_instance_ids" {
  value = [
    aws_instance.production_1.id,
    aws_instance.production_2.id
  ]
}

