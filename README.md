# precommit-terraform-example-module

## Overview
This module is for demo purposes, it's set up like a normal terraform module but is specifically be written with things
that will fail the pre-commit hooks. In this example repo there are currently 4 pre-commit hooks

* `terraform fmt` - This is responsible for formatting the terraform code. When this hook is run it will fail if any
  of the terraform code needs reformatted. NOTE: this will also reformat it for you so will pass on the next commit.
* `terraform validate` - This is responsible for checking the terraform code is syntactically correct. And will be able  
  to be parsed by the terraform exe and build a valid graph. Note it doesn't check things like attribute values are the
  correct type.
* `terraform docs` - This is not a built-in terraform command but instead a 3rd party tool. It will use the terraform
  docs tool to read through the terraform code and generate markdown tables and docs. This hook then inserts these in to
  the readme in the root of the repo. This hook will fail if it has to update the readme but will pass on the next commit
*  `tflint` - tflint is a 3rd party tool that does much more invasive linting of terraform code and supports plugins
   such as AWS that will be able to lint and detect failures on some attributes like instance or storage value that the
   normal terraform validate wont catch.

Pre-commit hooks can have some logic behind them to know if and when they should be run. for example the terraform
pre-commit hooks in this repo will only run if they see any of the .tf files in the git staging area being changed.
However should you want to you can ask pre-commit to run all hooks regardless of the files staged for the commit using:

```shell
pre-commit run --all
```

## pre-commit run example
I have run the above pre-commit command against the repo in its designed to be broken state, and we get the following
output.  I will break these into sections to talk about each hook

### Terraform fmt
In this case there are a number of issues with the terraform format. These are not syntax or validation issues. Just
best practice for code format and layout. The commit hook tells us which files were modified by the hook. Since this
hook will format the files for us. The next time its run it will pass since the code will have been formatted.

The bennifit of this is that some IDE's might format code differently, this will ensure all code regardless of the IDE
or engineer writing it will conform to the same standards.

```shell
Terraform fmt............................................................Failed
- hook id: terraform_fmt
- files were modified by this hook

main.tf
variables.tf
versions.tf
main.tf
variables.tf
versions.tf
```

### Terraform validation
This validation fails as I have specifically used a resource that does not exist within the provider. So when terraform
tries to validate this code it fails when checking the resource type. This is an example of validation ensuring syntax,
resources and attributes are valid. However, this tool cannot do validation of attribute values inside resources like
that an AWS instance type is a valid type. it can only check that its type matches what's being provided.

```shell
Terraform validate.......................................................Failed
- hook id: terraform_validate
- exit code: 1

Command 'terraform init' successfully done: .
Validation failed: .
╷
│ Error: Invalid resource type
│
│   on main.tf line 10, in resource "null_fake_resource" "dummy":
│   10: resource "null_fake_resource" "dummy" {}
│
│ The provider hashicorp/null does not support resource type
│ "null_fake_resource".
╵


Command 'terraform init' successfully done: examples/precommit-terraform-example-module
```

### Terraform docs
In this example it fails because the markdown for the terraform docs generated from the `.tf` files doesnt match the mark
down in the readme file. This will update the markdown in the read me file but be listed as a failure since it had to
change it. However now that its been updated the next time you run this it will pass (assuming no other changes were made
to `.tf` files)

```shell
Terraform docs...........................................................Failed
- hook id: terraform_docs
- files were modified by this hook
```

### TFLint
In this case I have purposefully defined variables that are not referenced in the code. TF lint has a
[terraform rule set](https://github.com/terraform-linters/tflint-ruleset-terraform/tree/v0.2.2/docs/rules) but also
supports a plugin architecture to allow other rules such as the
[aws rules set](https://github.com/terraform-linters/tflint-ruleset-aws/tree/master/rules) the allow for its functionality
to be extended and allows it to be able to do things like validate if an aws instance type is valid on AWS.

```shell
Terraform validate with tflint...........................................Failed
- hook id: terraform_tflint
- exit code: 2

Command 'tflint --init' successfully done:




TFLint in ./:
3 issue(s) found:

Warning: local.bob is declared but not used (terraform_unused_declarations)

  on main.tf line 3:
   3:   bob   = false

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

Warning: Missing version constraint for provider "null" in "required_providers" (terraform_required_providers)

  on main.tf line 10:
  10: resource "null_fake_resource" "dummy" {}

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_required_providers.md

Warning: variable "baz" is declared but not used (terraform_unused_declarations)

  on variables.tf line 10:
  10: variable "baz" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.2.2/docs/rules/terraform_unused_declarations.md

```

## Terraform Usage

```hcl
module "precommit-terraform-example-module" {
  source = "https://github.com/cdsre/precommit-terraform-example-module"
}
```

## Examples
There are a number of examples showing different flavours. These examples are not meant to be sourced into your terraform
but instead to act as a reference which you can copy or use as runable examples locally.

- [precommit-terraform-example-module](./examples/precommit-terraform-example-module)


# Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_fake_resource.dummy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/fake_resource) | resource |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bar"></a> [bar](#input\_bar) | n/a | `number` | `10` | no |
| <a name="input_baz"></a> [baz](#input\_baz) | This is the baz variable | `string` | `null` | no |
| <a name="input_foo"></a> [foo](#input\_foo) | n/a | `bool` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->