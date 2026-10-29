variable "name" {
  type        = string
  description = "Names"
}

variable "inline_policy" {
  type        = string
  description = "Permissions"
  default     = null

}

variable "managed_policy_arn" {
  type        = list(string)
  description = "Permissions Managed"
  default     = []

  validation {
    condition = (
      length(var.managed_policy_arn) > 0 ||
      var.inline_policy != null
    )
    error_message = "Informe pelo menos uma managed policy ou uma inline policy."
  }

}


variable "account_ids" {
  type = set(string)
}

variable "principals" {
  type = map(object({
    type = string
    id   = string
  }))
}

