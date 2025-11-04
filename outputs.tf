output "wordpress_site_url" {
  value       =  "http://${aws_instance.master.public_dns}"
  description = "URL for wordpress site"
}
