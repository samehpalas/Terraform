provider "aws" {
  region     = var.rgn
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr 

  tags = {
    Name = "${var.vpc-name}-vpcc"
  }
}


resource "aws_security_group" "example" {
 vpc_id = aws_vpc.main.id

 ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"		
    cidr_blocks      = [var.my_ip]

  }
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}
module "subnet-mod" {
  source = "./vpc-module/subnet"
  subnet_block=var.subnet_block
  avail_zone = var.avail_zone
  vpc-name = var.vpc-name
  vpc_id = aws_vpc.main.id #child module needs this variable from root module so passing it as shown
  default_route_table_id = aws_vpc.main.default_route_table_id
}
data "aws_ami" "app-ai" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
   }
}

resource "aws_key_pair" "deployer" {
  key_name   = "server_key"
  public_key = file(var.key_location) ##check it
}
resource "aws_instance" "web1" {
  ami           = data.aws_ami.app-ai.id
  instance_type = var.HW_specifications
  #PUT YOUR OWN KEY
  key_name 		= aws_key_pair.deployer.key_name
  subnet_id = module.subnet-mod.subnet.id #root module need from child module so import the exported there.
  availability_zone = var.avail_zone
  associate_public_ip_address = true 
  tags = {
    Name = "web-app"
  }
  vpc_security_group_ids = [aws_security_group.example.id]
  
}
/*resource "aws_security_group" "allow_ssh" {


 ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"		
    cidr_blocks      = [var.my_ip]

  }
 ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
}
*/