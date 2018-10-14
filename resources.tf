resource "aws_vpc" "environment-example-one" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "terraform-aws-vpc-example-one"
  }
}

resource "aws_subnet" "subnet1" {
  cidr_block = "${cidrsubnet(aws_vpc.environment-example-one.cidr_block,3,1 )}"
  # subnet cidr block points to the main vpc and defines a cidr block range for the subnet
  vpc_id = "${aws_vpc.environment-example-one.id}"
  #vpc id is automatically injected if there is only one vpc
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet2" {
  cidr_block = "${cidrsubnet(aws_vpc.environment-example-one.cidr_block,2,2)}"
  vpc_id = "${aws_vpc.environment-example-one.id}"
  availability_zone = "us-west-2b"
}

#the security group is for the subnets, but its applied to the VPC
resource "aws_security_group" "subnetsecuritygroup" {
  vpc_id = "${aws_vpc.environment-example-one.id}"


  ingress {
    cidr_blocks = [
     "${aws_vpc.environment-example-one.cidr_block}"
    ]

    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
}