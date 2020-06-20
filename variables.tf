variable "cluster_name" {
  description = "name(prefix) used for cluster resources"
  type        = string
  default     = "default-cluster"
}

variable "ami" {
  description = "AMI to run on cluster"
  type        = string
  default     = "ami-0278fe6949f6b1a06" # ubuntu image
}

variable "instance_type" {
  description = "EC2 type to run (eg. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "Server port for http request"
  type        = number
  default     = 8080
}

variable "server_message" {
  description = "Extra custom message for deployed docker image"
  type        = string
  default     = "Message from terraform!"
}
