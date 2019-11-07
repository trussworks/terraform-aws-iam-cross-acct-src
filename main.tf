#
# IAM Role
#
resource "aws_iam_role" "group" {
  name               = var.iam_role_name
  description        = "Role for user in the ${var.iam_role_name} group to assume."
  assume_role_policy = data.aws_iam_policy_document.role_assume_role_policy.json
}

# Configure a generic policy for assuming roles (require MFA)
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    # only allow folks in this account
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
    # only allow folks with MFA
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}

#
# Policy for the role
#
data "aws_iam_policy_document" "group_role_policy_doc" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = var.destination_group_role ? "${formatlist(format("arn:aws:iam::%%s:role/%s", var.destination_group_role), var.destination_account_ids)}" : "${formatlist("arn:aws:iam::%%s:role/root"), var.destination_account_ids)}" 
  }
}

resource "aws_iam_policy" "group_role_policy" {
  name        = "${var.iam_role_name}_role"
  path        = "/"
  description = "Policy for '${var.iam_role_name}' role permissions."
  policy      = data.aws_iam_policy_document.group_role_policy_doc.json
}

#
# Policy attachment
#
resource "aws_iam_role_policy_attachment" "group_role_policy_attachment" {
  role       = aws_iam_role.group.name
  policy_arn = aws_iam_policy.group_role_policy.arn
}
