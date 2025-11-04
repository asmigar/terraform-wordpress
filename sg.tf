data "http" "my_public_ip" {
	url = "https://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_ssh" {
	name        = "allow_tls"
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
		Name = "allow_ssh"
	}
}

