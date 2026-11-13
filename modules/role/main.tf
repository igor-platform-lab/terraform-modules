resource "aws_iam_role" "role" {
    assume_role_policy = 
  
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = var.policy_description
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = var.action
        Effect   = var.effect
        Resource = var.resource
      }
    ]
  })
}
