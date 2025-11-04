
data "aws_ami" "amazon_linux_2023" {
	most_recent = true
	owners      = ["amazon"]

	filter {
		name   = "name"
		values = ["al2023-ami-*"]
	}

	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}

	filter {
		name   = "architecture"
		values = ["arm64"]
	}
}



resource "aws_instance" "master" {
	ami           = data.aws_ami.amazon_linux_2023.id
	instance_type = "t4g.small"

	tags = {
		Name = "wordpress"
	}

	user_data_base64 = filebase64("${path.module}/setup.sh")

	vpc_security_group_ids = [aws_security_group.allow_ssh.id]
	subnet_id              = aws_subnet.public.id
	key_name               = aws_key_pair.this.key_name

	lifecycle {
		replace_triggered_by = [ aws_key_pair.this ]
	}
}


