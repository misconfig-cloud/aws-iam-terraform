provider "aws" {
  region = var.region
}

# Data sources for account ID and region
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Misconfig Role
resource "aws_iam_role" "misconfig-cloud-onboarding-role" {
  name               = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::730335354084:user/onboarding"
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.external_id}"
        }
      }
    }
  ]
}
EOF
}

# EventBridge Policy for the IAM role
resource "aws_iam_policy" "misconfig_eventbridge_policy" {
  name   = "Misconfig-EventBridge-Policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "events:PutRule",
        "events:DeleteRule",
        "events:PutTargets",
        "events:RemoveTargets",
        "events:CreateApiDestination",
        "events:UpdateApiDestination",
        "events:DeleteApiDestination",
        "events:CreateConnection",
        "events:UpdateConnection",
        "events:DeleteConnection",
        "events:DescribeEventBus",
        "events:CreateEventBus",
        "events:DeleteEventBus"
      ],
      "Resource": [
        "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:event-bus/misconfig-cloud",
        "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/misconfig-cloud/*",
        "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:api-destination/misconfig-cloud-ingest-destination/*",
        "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:connection/ApiConnection"
      ]
    },
{
      "Effect": "Allow",
      "Action": [
        "secretsmanager:CreateSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
        "secretsmanager:UpdateSecret",
        "secretsmanager:DeleteSecret"
      ],
      "Resource": [
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:ApiDestinationPasswordSecret-*",
        "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:ApiDestinationPasswordSecret"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreatePolicy",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:DeletePolicy",
        "iam:GetPolicy",
        "iam:ListPolicyVersions",
        "iam:GetRole",
        "iam:CreateRole",
        "iam:DeleteRole"
      ],
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/Amazon_EventBridge_Invoke_Api_Destination_Policy",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Amazon_EventBridge_Invoke_Api_Destination_Role"
      ]
    }
  ]
}
EOF
}


# CloudTrail Policy for the IAM role
resource "aws_iam_policy" "misconfig_cloudtrail_policy" {
  name   = "Misconfig-CloudTrail-Policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudtrail:CreateTrail",
        "cloudtrail:DeleteTrail",
        "cloudtrail:StartLogging",
        "cloudtrail:StopLogging",
        "cloudtrail:PutEventSelectors"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# CloudFormation Policy for the IAM role
resource "aws_iam_policy" "misconfig_cloudformation_policy" {
  name   = "Misconfig-CloudFormation-Policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:UpdateStack",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeStacks",
        "cloudformation:DescribeStackEvents",
        "cloudformation:DescribeStackResources",
        "cloudformation:ListStackResources",
        "cloudformation:ListStacks",
        "cloudtrail:PutInsightSelectors"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# S3 Bucket Policy for the IAM role
resource "aws_iam_policy" "misconfig_s3_bucket_policy" {
  name   = "Misconfig-S3-Bucket-Policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:PutEncryptionConfiguration",
        "s3:GetBucketAcl",
        "s3:PutObjectAcl",
        "s3:CreateBucket",
        "s3:PutBucketPublicAccessBlock",
        "s3:PutBucketEncryption",
        "s3:PutBucketOwnershipControls",
        "s3:PutBucketTagging",
        "s3:PutBucketPolicy",
        "s3:DeleteBucketPolicy",
        "s3:GetBucketPolicy",
        "s3:DeleteBucket",
        "s3:PutLifecycleConfiguration"
      ],
      "Resource": [
        "arn:aws:s3:::misconfig-aws-cloudtrail-logs-${data.aws_caller_identity.current.account_id}",
        "arn:aws:s3:::misconfig-aws-cloudtrail-logs-${data.aws_caller_identity.current.account_id}/*"
      ]
    }
  ]
}
EOF
}

# Attach S3 bucket policy to the role
resource "aws_iam_role_policy_attachment" "s3_bucket_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-role.name
  policy_arn = aws_iam_policy.misconfig_s3_bucket_policy.arn
}

# Attach CloudFormation policy to the role
resource "aws_iam_role_policy_attachment" "cloudformation_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-role.name
  policy_arn = aws_iam_policy.misconfig_cloudformation_policy.arn
}

# Attach EventBridge policy to the role
resource "aws_iam_role_policy_attachment" "eventbridge_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-role.name
  policy_arn = aws_iam_policy.misconfig_eventbridge_policy.arn
}

# Attach CloudTrail policy to the role
resource "aws_iam_role_policy_attachment" "cloudtrail_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-role.name
  policy_arn = aws_iam_policy.misconfig_cloudtrail_policy.arn
}

