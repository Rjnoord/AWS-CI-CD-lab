variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"{
  }
}

variable "vpc" {
  description = "The VPC ID to create resources in."
  type        = string
  default     = "rjnoord-aws-practice-lab-vpc"
}

variable "subnet_public_1a" {
  description = "The public subnet ID to create resources in."
  type        = string
  default     = "public-subnet-1a"
}

variable "subnet_private_1a" {
  description = "The private subnet ID to create resources in."
  type        = string
  default     = "private-subnet-1a"
}

variable "subnet_public_1b" {
  description = "The public subnet ID to create resources in."
  type        = string
  default     = "public-subnet-1b"
}

variable "subnet_private_1b" {
  description = "The private subnet ID to create resources in."
  type        = string
  default     = "private-subnet-1b"
}

variable "eip" {
  description = "The Elastic IP ID to create resources in."
  type        = string
  default     = "rjnoord-eip-a"
}

variable "igw" {
  description = "The Internet Gateway ID to create resources in."
  type        = string
  default     = "rjnoord-igw-2"
}

variable "nat" {
  description = "The NAT Gateway ID to create resources in."
  type        = string
  default     = "rjnoord-nat-gw-2"
}

variable "route_table_public" {
  description = "The public route table ID to create resources in."
  type        = string
  default     = "rjnoord-public-rt-2"
}

variable "private-rt" {
  description = "The private route table ID to create resources in."
  type        = string
  default     = "rjnoord-private-rt-2"
}

variable "public-rt-assoc" {
  description = "The public route table association ID to create resources in."
  type        = string
  default     = "rjnoord-public-rt-assoc-2"
}


variable "alb-sg" {
  description = "The security group ID for the ALB to create resources in."
  type        = string
  default     = "rjnoord-alb-sg"
}