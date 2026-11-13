variable "role_name" {
  type        = string
  description = "Nome da IAM role."
}

variable "assume_role_policy" {
  type        = string
  description = "Documento JSON de confiança que define quem pode assumir a role."
}

variable "policy_name" {
  type        = string
  description = "Nome da policy de permissões."
}

variable "policy_description" {
  type        = string
  description = "Descrição da policy de permissões."
  default     = null
}

variable "statements" {
  description = "Regras de permissão da policy."

  type = list(object({
    sid       = optional(string)
    effect    = optional(string, "Allow")
    actions   = list(string)
    resources = list(string)
  }))

  validation {
    condition     = length(var.statements) >= 1
    error_message = "Informe pelo menos um statement."
  }

  validation {
    condition = alltrue([
      for statement in var.statements :
      contains(["Allow", "Deny"], statement.effect)
    ])
    error_message = "O effect de cada statement deve ser Allow ou Deny."
  }

  validation {
    condition = alltrue([
      for statement in var.statements :
      length(statement.actions) > 0 && length(statement.resources) > 0
    ])
    error_message = "Cada statement deve conter pelo menos uma action e um resource."
  }
}