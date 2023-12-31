variable "foo" {
  type = bool
}

variable "bar" {
  type = number
  default = 10
}

variable "baz" {
  description = "This is the baz variable"
  type = string
  default = null
}
