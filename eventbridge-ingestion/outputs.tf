output "role_arn" {
  description = "The ARN of the IAM role created"
  value       = aws_iam_role.misconfig-cloud-onboarding-policy.arn
}