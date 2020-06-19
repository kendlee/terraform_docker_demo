variable "cluster_name" {
  description = "name(prefix) used for cluster resources"
  type        = string
  default     = "default-cluster"
}

variable "ami" {
  description = "AMI to run on cluster"
  type        = string
  default     = "ami-0278fe6949f6b1a06"
}

variable "instance_type" {
  description = "EC2 type to run (eg. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "minimum count for auto scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "maximum count for auto scaling group"
  type        = number
  default     = 1
}

variable "server_port" {
  description = "Server port for http request"
  type        = number
  default     = 8080
}

variable "target_group_arns" {
  description = "ARNs of ELB target groups in which to register instances"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "user data script to run in instances during boot"
  type        = string
  default     = null
}
