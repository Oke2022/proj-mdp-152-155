module "Bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Bastion-host"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0423294c92c4f4a15"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-09bcd3726608527f1"]
  private_ip             = "10.0.0.5"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ans-master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Ansible-master"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08af16aaaf6ef0df7"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0a09749fa8a4925a5"]
  private_ip             = "10.0.0.140"
  monitoring             = true
  user_data = file("${path.module}/setup-ansible.sh")


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "build-server" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Build-server"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08af16aaaf6ef0df7"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-06ecd30088d2bf940"]
  private_ip             = "10.0.0.135"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "app-server" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "App-server"
  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08af16aaaf6ef0df7"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0dfd7d6ad44ccf555"]
  private_ip             = "10.0.0.150"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

