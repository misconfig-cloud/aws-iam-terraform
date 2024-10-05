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

# Main IAM role for Misconfig Cloud
resource "aws_iam_role" "misconfig_cloud_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.misconfig_account_id}"
      },
      "Action": "sts:AssumeRole",
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

