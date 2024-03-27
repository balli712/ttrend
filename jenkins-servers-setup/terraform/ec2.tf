data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240301"]
  }
}

resource "random_id" "mtc_node_id" {
  byte_length = 2
  count       = var.main_instance_count
}

# resource "aws_key_pair" "mtc_auth" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }


resource "aws_instance" "jenkins-master" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = "ec2-key"
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet[0].id
  # user_data = templatefile("./main-userdata.tpl", {new_hostname = "mtc-main-${random_id.mtc_node_id[count.index].dec}"})
  root_block_device {
    volume_size = var.main_vol_size
  }
  
  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_instance" "jenkins-slave" {
  instance_type          = "t2.medium"
  ami                    = data.aws_ami.server_ami.id
  key_name               = "ec2-key"
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet[0].id
  # user_data = templatefile("./main-userdata.tpl", {new_hostname = "mtc-main-${random_id.mtc_node_id[count.index].dec}"})
  root_block_device {
    volume_size = var.main_vol_size
  }
  
  tags = {
    Name = "jenkins-slave"
  }
}

resource "aws_eip" "jenkins-master" {
  instance = aws_instance.jenkins-master.id
  domain   = "vpc"
}

resource "aws_eip" "jenkins-slave" {
  instance = aws_instance.jenkins-slave.id
  domain   = "vpc"
}

# resource "aws_instance" "demo-server" {
#   ami           = "ami-053b0d53c279acc90"
#   instance_type = "t2.micro"
#   key_name      = "dpp"
#   //security_groups = [ "demo-sg" ]
#   vpc_security_group_ids = [aws_security_group.demo-sg.id]
#   subnet_id              = aws_subnet.dpp-public-subnet-01.id
#   for_each               = toset(["jenkins-master", "build-slave", "ansible"])
#   tags = {
#     Name = "${each.key}"
#   }
# }