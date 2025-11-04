
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



resource "aws_instance" "wordpress" {
	ami           = data.aws_ami.amazon_linux_2023.id
	instance_type = "t4g.small"

	tags = {
		Name = "wordpress"
	}

	user_data = templatefile("${path.module}/setup.sh.tftpl", {db_endpoint = aws_rds_cluster.wordpress.endpoint})

	vpc_security_group_ids = [aws_security_group.wordpress.id]
	subnet_id              = aws_subnet.public.id
	key_name               = aws_key_pair.this.key_name

	lifecycle {
		replace_triggered_by = [ aws_key_pair.this ]
	}

	provisioner "local-exec" {
		command = "until nc -z ${self.public_dns} 80; do sleep 1; done"
	}
}


