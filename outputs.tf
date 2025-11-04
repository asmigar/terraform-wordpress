output "wordpress_instance" {
  value       =  "ssh -i ~/.ssh/${aws_key_pair.this.key_name}.pem ec2-user@${aws_instance.master.public_dns}"
  description = "ssh command for connecting to the wordpress instance"
}

