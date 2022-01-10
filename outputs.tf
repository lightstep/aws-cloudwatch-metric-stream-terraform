output "role_arn" {
  value = aws_iam_role.lightstep_role[0].arn
}

output "external_id" {
  value = random_string.external_id.result
}