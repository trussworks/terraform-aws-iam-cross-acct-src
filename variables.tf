variable "iam_role_name" {
  description = "The name for the role. Conceptually, this should correspond to a group."
  type        = string
}

variable "destination_account_ids" {
  description = "The account ids where the target role the call is assuming resides."
  type        = list
  default     = []
}

variable "destination_group_role" {
  description = "The name of the role in the account to be assumed. Again, this should correspond to a group."
  type        = string
  default     = ""
}

variable "require_mfa" {
  description = "Whether the created policy will include MFA."
  type        = bool
  default     = true
}

variable "mfa_condition" {
  description = "MFA condition method. Use either Bool or BoolIfExists"
  type        = string
  default     = "Bool"
}

variable "role_assumption_max_duration" {
  description = "Max duration that the assumed role is assumed for Must be between 3600 and 43200 (including)"
  type        = number
  default     = 3600
}
