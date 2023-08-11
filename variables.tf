
variable "public_cidrs" {

  type        = list(string)
  description = "CIDR Blocks for Public Subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_cidrs" {
  type        = list(string)
  description = "CIDR Blocks for Private Subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

}

variable "azs" {
  type        = list(string)
  description = "AZs"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "couting" {
  type    = string
  default = "something cool"

}