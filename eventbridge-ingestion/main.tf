provider "aws" {
  region = var.region
}

resource "aws_iam_role" "misconfig-cloud-onboarding-policy" {
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
        "events:DeleteConnection"
      ],
      "Resource": "*"
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
        "cloudtrail:StopLogging"
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
        "cloudformation:ListStacks"
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
        "s3:CreateBucket",
        "s3:PutBucketPublicAccessBlock",
        "s3:PutBucketEncryption",
        "s3:PutBucketOwnershipControls",
        "s3:PutBucketTagging"
      ],
      "Resource": "arn:aws:s3:::misconfig-aws-cloudtrail-logs-${var.aws_account_id}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::misconfig-aws-cloudtrail-logs-${var.aws_account_id}",
        "arn:aws:s3:::misconfig-aws-cloudtrail-logs-${var.aws_account_id}/*"
      ]
    }
  ]
}
EOF
}

# Attach S3 bucket policy to the role
resource "aws_iam_role_policy_attachment" "s3_bucket_policy_attach" {
  role       = aws_iam_role.misconfig_cloud_role.name
  policy_arn = aws_iam_policy.misconfig_s3_bucket_policy.arn
}

# Attach CloudFormation policy to the role
resource "aws_iam_role_policy_attachment" "cloudformation_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-policy.name
  policy_arn = aws_iam_policy.misconfig_cloudformation_policy.arn
}

# Attach EventBridge policy to the role
resource "aws_iam_role_policy_attachment" "eventbridge_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-policy.name
  policy_arn = aws_iam_policy.misconfig_eventbridge_policy.arn
}

# Attach CloudTrail policy to the role
resource "aws_iam_role_policy_attachment" "cloudtrail_policy_attach" {
  role       = aws_iam_role.misconfig-cloud-onboarding-policy.name
  policy_arn = aws_iam_policy.misconfig_cloudtrail_policy.arn
}

