#Bastion Host instance

resource "aws_instance" "bastion-host" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.pub-sub-1.id
  key_name      = "my-key"
  vpc_security_group_ids = "bastion-sg"
  private_ip = "10.0.0.5"

  tags = {
    Name = "bastion-host"
  }
}



#Ansible master instance

resource "aws_instance" "ansible-master" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.priv-sub-1.id
  key_name      = "my-key"
  vpc_security_group_ids = "ansible-sg"
  user_data = file("install-ansible.sh")
  private_ip = "10.0.0.5"

  tags = {
    Name = "ansible-master"
  }
}


#Build server instance

resource "aws_instance" "build-server" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.priv-sub-1.id
  key_name      = "my-key"
  vpc_security_group_ids = "build-sg"
  user_data = file("build-srv-setup.sh")
  private_ip = "10.0.0.4"

  tags = {
    Name = "build-server"
  }
}

#App instance

resource "aws_instance" "app-server" {
  ami           = "ami-04f167a56786e4b09"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.priv-sub-1.id
  key_name      = "my-key"
  vpc_security_group_ids = "app-sg"
  user_data = file("app-srv-setup.sh")
  private_ip = "10.0.0.2"

  tags = {
    Name = "app-server"
  }
}
