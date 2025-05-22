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

