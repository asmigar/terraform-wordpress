variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ssh_key_name" {
  type        = string
  default     = "wordpress"
  description = "ssh key name to be created in EC2 and store in ~/.ssh folder"
}
variable "db_password" {
  type = string
  sensitive = true
  description = "database password"
}