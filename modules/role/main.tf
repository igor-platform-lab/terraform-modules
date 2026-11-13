resource "aws_iam_role" "role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"

        Principal = {
          Service = var.trusted_services
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = var.policy_description
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      for statement in var.statements : merge(
        {
          Effect   = statement.effect
          Action   = statement.actions
          Resource = statement.resources
        },
        statement.sid != null ? { Sid = statement.sid } : {}
      )
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}