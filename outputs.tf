output "arn" {
  description = "The arn for the created role."
  value       = aws_iam_role.group.arn
}

output "name" {
  description = "The name for the created role."
  value       = aws_iam_role.group.name
}
