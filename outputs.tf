output "iam_role_arn" {
  description = "The arn for the created role."
  value       = aws_iam_role.group.arn
}

output "iam_role_name" {
  description = "The name for the created role."
  value       = aws_iam_role.group.name
}
