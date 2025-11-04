data "http" "my_public_ip" {
	url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "wordpress" {
	name        = "wordpress"
	description = "Allow TLS inbound traffic"
	vpc_id      = aws_vpc.main.id

	ingress {
		description = "ssh"
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
	}

	ingress {
		description = "wordpress site"
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
	}

	egress {
		from_port        = 0
		to_port          = 65535
		protocol         = "tcp"
		cidr_blocks      = ["0.0.0.0/0"]
		ipv6_cidr_blocks = ["::/0"]

	}

	tags = {
		Name = "Wordpress"
	}
}


resource "aws_security_group" "db" {
	name        = "db"
	description = "Allow DB inbound traffic"
	vpc_id      = aws_vpc.main.id

	ingress {
		description = "tcp"
		from_port   = 3306
		to_port     = 3306
		protocol    = "tcp"
		security_groups = [aws_security_group.wordpress.id]
	}

	tags = {
		Name = "DB"
	}
}


