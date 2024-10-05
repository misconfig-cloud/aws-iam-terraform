# Terraform Module: Customer IAM Role for misconfig.cloud

This Terraform module provisions an IAM role in the customer’s AWS account, allowing misconfig.cloud to assume the role and deploy resources such as EventBridge rules, CloudTrail, API destinations, and connections.

## Overview

This module creates an IAM role that allows misconfig.cloud to execute CloudFormation or Terraform actions in the customer’s AWS account. The role is configured with permissions necessary to manage the following services:

- **AWS EventBridge**: Create, update, and delete rules, targets, API destinations, and connections.
- **AWS CloudTrail**: Manage CloudTrail trails for audit logging purposes.

misconfig.cloud will assume this role to deploy and manage AWS infrastructure needed to detect and handle misconfigurations across customer accounts.

## Features

- **Assume Role**: misconfig.cloud uses this IAM role to execute CloudFormation or Terraform in your AWS account.
- **EventBridge Management**: Permissions to create, manage, and delete EventBridge rules, API destinations, and connections.
- **CloudTrail Management**: Permissions to create and manage CloudTrail logging.

## Requirements

- Terraform 0.13 or newer
- AWS Account
- IAM permissions to deploy resources

## Usage

Here is how you can use this module in your Terraform configuration:

```hcl
module "eventbridge-ingestion" {
  source                = "git::https://github.com/misconfig-cloud/aws-iam-terraform.git//eventbridge-ingestion"
  external_id           = "123"   # The external ID given by Misconfig.cloud
  aws_account_id        = "730335354084"  # This is your AWS account ID that will be used for the role template
}

```

### Inputs

| Name                        | Description                                                                   | Type   | Default                       | Required |
|-----------------------------|-------------------------------------------------------------------------------|--------|-------------------------------|----------|
| `external_id`            | The external ID provided by Misconfig.cloud                             | string | N/A                           | Yes      |
| `role_name`                  | The name of the IAM role to be created                                        | string | `CloudFormationExecutionRole`  | No       |

### Outputs

| Name        | Description                    |
|-------------|--------------------------------|
| `role_arn`  | The ARN of the IAM role created |

## Permissions Granted

The IAM role created by this module has the following permissions:

### EventBridge

- `events:PutRule`
- `events:DeleteRule`
- `events:PutTargets`
- `events:RemoveTargets`
- `events:CreateApiDestination`
- `events:UpdateApiDestination`
- `events:DeleteApiDestination`
- `events:CreateConnection`
- `events:UpdateConnection`
- `events:DeleteConnection`

### CloudTrail

- `cloudtrail:CreateTrail`
- `cloudtrail:DeleteTrail`
- `cloudtrail:StartLogging`
- `cloudtrail:StopLogging`

## Regional Considerations

This IAM role is global, but actions executed via this role, such as creating EventBridge rules or CloudTrail trails, will be regional. misconfig.cloud will assume this role and deploy resources to the appropriate AWS regions based on the customer’s requirements.

## Security and Best Practices

- The permissions granted by this module are scoped broadly to allow misconfig.cloud to manage infrastructure across different regions.
- We recommend regularly reviewing the permissions and monitoring the use of the role via AWS CloudTrail logs.

## License

This module is licensed under the Apache 2.0 License. See [LICENSE](./LICENSE) for details.

## Support

For any questions or support, please reach out to the misconfig.cloud team at [support@misconfig.cloud](mailto:support@misconfig.cloud).
