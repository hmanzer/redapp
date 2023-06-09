#####
# VPC
#####
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr_block
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  tags = {
    Name = var.vpc_name
  }
}


#####
# Public subnets (2)
#####

resource "aws_subnet" "public_main_1" {
  depends_on = [ aws_vpc.main ]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1
  ipv6_cidr_block         = var.enable_ipv6 ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, "1") : ""
  availability_zone       = var.public_availability_zone_1
  map_public_ip_on_launch = true
  tags = {
    Name = format("public/%s/%s", var.vpc_name, var.public_availability_zone_1)
  }
}

# resource "aws_subnet" "public_main_2" {
#   depends_on = [ aws_vpc.main ]
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.public_subnet_2
#   ipv6_cidr_block         = var.enable_ipv6 ? cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, "2") : ""
#   availability_zone       = var.public_availability_zone_2
#   map_public_ip_on_launch = true
#   tags = {
#     Name = format("public/%s/%s", var.vpc_name, var.public_availability_zone_2)
#   }
# }

##### 
# Private subnets (2)
#####
resource "aws_subnet" "private_main_1" {
  depends_on = [ aws_vpc.main ]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_1
  availability_zone       = var.private_availability_zone_1
  map_public_ip_on_launch = false
  tags = {
    Name = format("private/%s/%s", var.vpc_name, var.private_availability_zone_1)
  }
}

# resource "aws_subnet" "private_main_2" {
#   depends_on = [ aws_vpc.main ]
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = var.private_subnet_2
#   availability_zone       = var.private_availability_zone_2
#   map_public_ip_on_launch = false
#   tags = {
#     Name = format("private/%s/%s", var.vpc_name, var.private_availability_zone_2)
#   }
# }

#####
# IPv4 Internet gateway for VPC--> public internet
#####
resource "aws_internet_gateway" "public_main" {
  depends_on = [ aws_vpc.main, aws_subnet.public_main_1, aws_subnet.public_main_2]
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_route_table" "public_subnet_RT" {
  depends_on = [ aws_vpc.main, aws_internet_gateway.public_main ]
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_main.id
  }
  tags = {
    Name = "Public subnet Route Table"
  }
}
resource "aws_route_table_association" "public_main_1_RT_association" {
  depends_on = [ aws_vpc.main, aws_subnet.public_main_1, aws_route_table.public_subnet_RT  ]
  subnet_id = aws_subnet.public_main_1.id
  route_table_id = aws_route_table.public_subnet_RT.id

}

# resource "aws_route_table_association" "public_main_2_RT_association" {
#   depends_on = [ aws_vpc.main, aws_subnet.public_main_2, aws_route_table.public_subnet_RT  ]
#   subnet_id = aws_subnet.public_main_2.id
#   route_table_id = aws_route_table.public_subnet_RT.id

# }

#####
# NAT Gateway for VPC--> for private subnets
#####

resource "aws_eip" "Nat-Gateway-EIP-1" {
  vpc = true
}

resource "aws_nat_gateway" "NAT_GATEWAY-1" {
  depends_on = [
    aws_eip.Nat-Gateway-EIP-1
  ]

  allocation_id = aws_eip.Nat-Gateway-EIP-1.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.private_main_1.id
  tags = {
    Name = "Nat-Gateway_1"
  }
}

# resource "aws_eip" "Nat-Gateway-EIP-2" {
#   vpc = true
# }

# resource "aws_nat_gateway" "NAT_GATEWAY-2" {
#   depends_on = [
#     aws_eip.Nat-Gateway-EIP-2
#   ]

#   allocation_id = aws_eip.Nat-Gateway-EIP-2.id
  
#   # Associating it in the Public Subnet!
#   subnet_id = aws_subnet.private_main_2.id
#   tags = {
#     Name = "Nat-Gateway_2"
#   }
# }

resource "aws_route_table" "Private-subnet-1-RT" {
  depends_on = [
    aws_nat_gateway.NAT_GATEWAY-1
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GATEWAY-1.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

resource "aws_route_table_association" "NAT-Gateway-RT-Association" {
  depends_on = [
    aws_route_table.NAT-Gateway-RT-1
  ]
  subnet_id      = aws_subnet.private_main_1.id
  
  route_table_id = aws_route_table.Private-subnet-1-RT.id
}