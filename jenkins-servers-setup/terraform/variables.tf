variable "vpc_cidr" {
  type = string
}

variable "my_ip" {
  type = string
}


variable "main_vol_size" {
  type = number
}

variable "main_instance_count" {
  type = number
}

# variable "key_name" {
#   type = string
# }

# variable "public_key_path" {
#   type = string
# }

# variable "public_cidrs" {
# 	type = list(string)
# }

# variable "private_cidrs" {
#     type = list(string)
# }

locals {
  azs = data.aws_availability_zones.available.names
}