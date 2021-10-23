variable "read_capacity" {
    default = 10
}

variable "write_capacity" {
    default = 10
}

variable "log_retention_in_days" {
  description = "The number of days to retain logs in CloudWatch"
  default     = 1
}

