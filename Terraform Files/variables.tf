variable "instance_type" {
  description = "Type of instance to be created"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair to be used for SSH"
  type        = string
  default = "deployer-key"
}
