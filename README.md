This module creates an IAM role based on the "group_name" variable. This should correspond 1:1 with an IAM group though you will need to associate the role with the group outside of this module. This module defines the roles this role may assume with a corresponding name defined in "destination_group_role"

_Philosophical note_: There should be a single account in your AWS organization that manages users and groups. In that account, there will be a 1:1 mapping to a group and a role. This module creates that role. The main purpose of this role will be to manage AssumeRole permissions to multiple other accounts in this AWS organization that have corresponding roles to this group.
The role defined in this module should be one of those roles that can be assumed by the role in the original user management account.
An additional IAM policy should be defined locally in this account for any permissions this group may have in the source account and assigned to the role defined here.

## Usage

### Put an example usage of the module here

```hcl
module "aws_iam_src_user_group_role" {
  source = "trussworks/iam-cross-acct-src/aws"
  version = "1.0.0"
  group_name = "group-name"
  destination_account_ids = ["account-id"]
  destination_account_role_name = "group-name"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination\_account\_ids | The account ids where the target role the call is assuming resides. | list | n/a | yes |
| destination\_group\_role | The name of the role in the account to be assumed. Again, this should correspond to a group. | string | n/a | yes |
| group\_name | The name for the role. Conceptually, this should correspond to a group. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_arn | The arn for the created role. |
| iam\_role\_name | The name for the created role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
