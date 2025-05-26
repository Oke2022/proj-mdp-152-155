module "Bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Bastion-host"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0cb3f547d61223235"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0eb70371f736a9c9d"]
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
  subnet_id              = "subnet-01b57504318845331"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-05619a19aef3824ab"]
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
  subnet_id              = "subnet-01b57504318845331"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0330a1ec75bf2147c"]
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
  subnet_id              = "subnet-0cb3f547d61223235"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0ddc2e95d99d86a25"]
  private_ip             = "10.0.0.10"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "JenkinsAndDocker-server" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "JenkinsAndDocker-server"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0cb3f547d61223235"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-0c2c3b8309c6a6967"]
  private_ip             = "10.0.0.15"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "k8-master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "k8-master"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t3.medium"
  subnet_id              = "subnet-0cb3f547d61223235"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-08f1b7a07c598f7e9"]
  private_ip             = "10.0.0.20"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "k8-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "k8-worker"

  ami                    = "ami-04f167a56786e4b09"
  instance_type          = "t3.medium"
  subnet_id              = "subnet-0afa481b339083ed9"
  key_name               = "my-key1"
  vpc_security_group_ids = ["sg-08f1b7a07c598f7e9"]
  private_ip             = "10.0.1.5"
  monitoring             = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}



# K8 S3 bucket
resource "aws_s3_bucket" "kops_state" {
  bucket = "cal-kops-state-bucket"

  tags = {
    Name        = "k8-bucket"
    Environment = "prod"
  }
}
