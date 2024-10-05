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

# Attach a policy to the role, such as a managed policy for EventBridge and CloudTrail permissions
resource "aws_iam_policy" "misconfig-cloud-onboarding-policy" {
  name        = "MisconfigCloudOnboardingPolicy"
  description = "Policy to onboard EventBridge rules and CloudTrails with Misconfig Cloud"
  policy      = <<EOF
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
        "cloudtrail:CreateTrail",
        "cloudtrail:DeleteTrail",
        "cloudtrail:StartLogging",
        "cloudtrail:StopLogging",
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

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "misconfig-cloud-onboarding-policy" {
  role       = aws_iam_role.misconfig-cloud-onboarding-policy.name
  policy_arn = aws_iam_policy.misconfig-cloud-onboarding-policy.arn
}