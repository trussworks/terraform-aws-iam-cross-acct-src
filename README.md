This module creates an IAM role based on the "iam_role_name" variable. This should correspond 1:1 with an IAM group though you will need to associate the role with the group outside of this module. This module defines the roles this role may assume with a corresponding name defined in "destination_group_role". This module also defaults to enforcing MFA as a requirement for role assumption.

_Philosophical note_: There should be a single account in your AWS organization that manages users and groups. In that account, there will be a 1:1 mapping to a group and a role. This module creates that role. The main purpose of this role will be to manage AssumeRole permissions to multiple other accounts in this AWS organization that have corresponding roles to this group.
The role defined in this module should be one of those roles that can be assumed by the role in the original user management account.
An additional IAM policy should be defined locally in this account for any permissions this group may have in the source account and assigned to the role defined here.

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

## Example usage

```hcl

module "infra_group_role" {
  source = "../../modules/src-role-to-assume"
  iam_role_name = "infra"
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
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination\_account\_ids | The account ids where the target role the call is assuming resides. | list | n/a | yes |
| destination\_group\_role | The name of the role in the account to be assumed. Again, this should correspond to a group. | string | n/a | yes |
| iam\_role\_name | The name for the role. Conceptually, this should correspond to a group. | string | n/a | yes |
| mfa\_present | Whether the created policy will include MFA. | string | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | The arn for the created role. |
| iam\_role\_name | The name for the created role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
