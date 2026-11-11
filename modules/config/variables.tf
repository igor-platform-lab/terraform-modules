variable "organization" {
  type        = list(string)
  description = "Config Rule depends on Organization"

}

variable "config_rule_name" {
  type        = string
  description = "Config Rule Name"
}

variable "rule" {
  type        = string
  description = "Rule to be applied."
}