output "integration_role_arn" {
  value = aws_iam_role.lightstep_role[0].arn
  description = "The ARN of the role Lightstep will use to retrieve resource metadata. It must be entered into the Lightstep UI to complete the integration."
}

output "external_id" {
  value = random_string.external_id.result
  description = "A unique string which identifies Ligtstep to your AWS account when we pull resource metadata. It must be entered into the Lightstep UI to complete the integration. For details, see https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html"
}