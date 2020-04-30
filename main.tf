data "aws_partition" "current" {}

#
# IAM Role
#
resource "aws_iam_role" "group" {
  name               = var.iam_role_name
  description        = "Role for user in the ${var.iam_role_name} group to assume."
  assume_role_policy = data.aws_iam_policy_document.role_assume_role_policy.json
}

# Configure a generic policy for assuming roles (conditional MFA)
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    # only allow folks in this account
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    # Conditionally require MFA (defaults to true)
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = [tostring(var.require_mfa)]
    }
  }
}

#
# Policy for the role
#
data "aws_iam_policy_document" "group_role_policy_doc" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = "${formatlist(format("arn:${data.aws_partition.current.partition}:iam::%%s:role/%s", var.destination_group_role), var.destination_account_ids)}"
  }
}

resource "aws_iam_policy" "group_role_policy" {
  count       = length(var.destination_account_ids) > 0 ? 1 : 0
  name        = "${var.iam_role_name}_role"
  path        = "/"
  description = "Policy for '${var.iam_role_name}' role permissions."
  policy      = data.aws_iam_policy_document.group_role_policy_doc.json
}

#
# Policy attachment
#
resource "aws_iam_role_policy_attachment" "group_role_policy_attachment" {
  count      = length(var.destination_account_ids) > 0 ? 1 : 0
  role       = aws_iam_role.group.name
  policy_arn = concat(aws_iam_policy.group_role_policy.*.arn, [""])[0]
}
