# Truss Terraform Module template

This repository is meant to be a template repo we can just spin up new module repos from with our general format.

## How to

## Actual readme below  - Delete above here

Please put a description of what this module does here

## Terraform Versions

_This is how we're managing the different versions._
Terraform 0.12. Pin module version to ~> 2.0. Submit pull-requests to master branch.

Terraform 0.11. Pin module version to ~> 1.0. Submit pull-requests to terraform011 branch.

## Usage

### Put an example usage of the module here

```hcl
module "example" {
  source = "terraform/registry/path"

  <variables>
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination\_accounts | The account id where the target role the call is assuming resides. | list | n/a | yes |
| destination\_group\_role | The name of the role in the account to be assumed. Again, this should correspond to a group. | string | n/a | yes |
| group\_name | The name for the role. Conceptually, this should correspond to a group. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | The arn for the created role. |
| name | The name for the created role. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
