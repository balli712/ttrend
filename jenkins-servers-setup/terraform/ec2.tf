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


resource "aws_instance" "demo-server" {
  for_each = toset(["jenkins-master", "jenkins-slave"])
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = "ec2-key"
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet[0].id
  # user_data = templatefile("./main-userdata.tpl", {new_hostname = "mtc-main-${random_id.mtc_node_id[count.index].dec}"})
  root_block_device {
    volume_size = var.main_vol_size
  }
  
  tags = {
    Name = "${each.key}"
  }
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