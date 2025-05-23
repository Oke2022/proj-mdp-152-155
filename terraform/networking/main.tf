#Create a VPC with 250 IPs for my App
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/23"
  instance_tenancy = "default"
  enable_dns_support = "true"

  tags = {
    Name = "app-vpc"
  }
}

#Internet gateway
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-igw"
  }
}

#Elastic Ip for public subnet
resource "aws_eip" "pub-eip" {
  domain   = "vpc"
}

#Public subnet-1
resource "aws_subnet" "pub-sub-1" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
  tags = {
    Name = "pub-sub-1"
  }
}


#Public subnet-2
resource "aws_subnet" "pub-sub-2" {
  vpc_id                  = aws_vpc.app-vpc.id
  cidr_block              = "10.0.1.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"

  tags = {
    Name = "pub-sub-2"
  }
}



#Private subnet-1
resource "aws_subnet" "priv-sub-1" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.0.128/25"
  availability_zone       = "us-east-2a"

  tags = {
    Name = "priv-sub-1"
  }
}


#Private subnet-2
resource "aws_subnet" "priv-sub-2" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.1.128/25"
  availability_zone       = "us-east-2b"

  tags = {
    Name = "priv-sub-2"
  }
}


#NAT gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.pub-eip.id
  subnet_id     = aws_subnet.pub-sub-1.id

  tags = {
    Name = "nat-gw"
  }

  depends_on = [aws_internet_gateway.app-igw]
}


#Public route table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }

  tags = {
    Name = "pub-rt"
  }
}

#Public route Association

#Public subnet 1
resource "aws_route_table_association" "pub-sub-1-rt-ass" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-rt.id
}

#Public subnet 2
resource "aws_route_table_association" "pub-sub-2-rt-ass" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.pub-rt.id
}

#Private route table
resource "aws_route_table" "priv-rt" {
  vpc_id = aws_vpc.app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "priv-rt"
  }
}


#Private route Association

#Private subnet 1
resource "aws_route_table_association" "priv-sub-1-rt-ass" {
  subnet_id      = aws_subnet.priv-sub-1.id
  route_table_id = aws_route_table.priv-rt.id
}

#Private subnet 2
resource "aws_route_table_association" "priv-sub-2-rt-ass" {
  subnet_id      = aws_subnet.priv-sub-2.id
  route_table_id = aws_route_table.priv-rt.id
}



#Security groups 

#Bation Host security group
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Allow SSH inbound traffic from MY IP and all outbound traffic"
  vpc_id      = aws_vpc.app-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["99.127.213.4/32"]
  }
  
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

#Ansible Master security group
resource "aws_security_group" "ansible-sg" {
  name        = "ansible-sg"
  description = "Allow SSH inbound traffic from Bastion Host and all outbound traffic"
  vpc_id      = aws_vpc.app-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.5/32"]
  }
  
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-sg"
  }
}


#Build server security group
resource "aws_security_group" "build-sg" {
  name        = "build-sg"
  description = "Allow SSH inbound traffic from Bastion Host and all outbound traffic"
  vpc_id      = aws_vpc.app-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.5/32"]
  }
  

    ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.140/32"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "build-sg"
  }
}
#App server security group
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "Allow SSH inbound traffic from Bastion Host and all outbound traffic"
  vpc_id      = aws_vpc.app-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.5/32"]
  }

   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.140/32"]
  }

   ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-sg"
  }
}



#JenkinsAndDocker server security group
resource "aws_security_group" "jenkinsAndDorker-sg" {
  name        = "jenkinsAndDocker-sg"
  description = "Allow SSH inbound traffic from Bastion Host and ansible, allow port 50000 for docker, and port 8080 for jenkins and all outbound traffic"
  vpc_id      = aws_vpc.app-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.5/32"]
  }

   ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.140/32"]
  }

   ingress {
    from_port        = 50000
    to_port          = 50000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkinsAndDocker-sg"
  }
}



