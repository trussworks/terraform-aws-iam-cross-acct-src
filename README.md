---

# End of Life notice

**This module is no longer in active development because we have switched from role-chaining to direct role assumption. See the [`terraform-layout-example`](https://github.com/trussworks/terraform-layout-example) for our implementation.**

---


This module creates an IAM role based on the `iam_role_name` variable. This should correspond 1:1 with an IAM group though you will need to associate the role with the group outside of this module.

_Optional_: If you specify `destination_account_ids` and `destination_group_role`, the module will create an IAM policy granting the IAM role permission to assume `destination_group_role` in the `destination_account_ids`. If `destination_account_ids` and `destination_group_role` are not provided, this module will create an IAM role, but will not attach an IAM policy to it.

An additional IAM policy should be defined locally in this account for any permissions this group may have in the source account and assigned to the role defined here.

This module also defaults to enforcing MFA as a requirement for role assumption.

_Philosophical note_: There should be a single account in your AWS organization that manages users and groups. In that account, there will be a 1:1 mapping to a group and a role. This module creates that role. The main purpose of this role will be to manage AssumeRole permissions to multiple other accounts in this AWS organization that have corresponding roles to this group.
The role defined in this module should be one of those roles that can be assumed by the role in the original user management account.

## Usage

```hcl

module "aws_iam_src_user_group_role" {
  source = "trussworks/iam-cross-acct-src/aws"
  version = "1.0.0"
  iam_role_name = "group-name"
  destination_account_ids = ["account-id"]
  destination_account_role_name = "group-name"
}
```

## Example usage with cross-account role assumption permission

```hcl

data "aws_partition" "current" {}

module "infra_group_role" {
  source = "trussworks/iam-cross-acct-src/aws"
  version = "1.0.0"
  destination_account_ids = ["ACCOUNT-ID-1", "ACCOUNT-ID-2"]
  destination_group_role = "infra"
}

# Module for user group creation. Does not create users.
module "infra_group" {
  source  = "trussworks/iam-user-group/aws"
  version = "1.0.1"

  user_list     = ["user1", "user2", "user3"]
  allowed_roles = [module.infra_group_role.arn]
  iam_role_name    = "infra"
}

# Additional policy for local account management
resource "aws_iam_role_policy_attachment" "infra_local_policy_attatchment" {
  role = module.infra_group_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/PowerUserAccess"
}

```

## Example usage without cross-account role assumption permission or mfa requirement

```hcl

data "aws_partition" "current" {}

module "infra_group_role" {
  source = "trussworks/iam-cross-acct-src/aws"
  version = "1.0.0"
  require_mfa = false
}

# Module for user group creation. Does not create users.
module "infra_group" {
  source  = "trussworks/iam-user-group/aws"
  version = "1.0.1"

  user_list     = ["user1", "user2", "user3"]
  allowed_roles = [module.infra_group_role.arn]
  iam_role_name    = "infra"
}

# Additional policy for local account management
resource "aws_iam_role_policy_attachment" "infra_local_policy_attatchment" {
  role = module.infra_group_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/PowerUserAccess"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| destination\_account\_ids | The account ids where the target role the call is assuming resides. | `list` | `[]` | no |
| destination\_group\_role | The name of the role in the account to be assumed. Again, this should correspond to a group. | `string` | `""` | no |
| iam\_role\_name | The name for the role. Conceptually, this should correspond to a group. | `string` | n/a | yes |
| require\_mfa | Whether the created policy will include MFA. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | The arn for the created role. |
| iam\_role\_name | The name for the created role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
