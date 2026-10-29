resource "aws_ssoadmin_permission_set" "permission_set" {
  instance_arn     = local.instance_arn
  name             = var.name
  session_duration = "PT2H"
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  inline_policy      = var.inline_policy
  count              = var.inline_policy != null ? 1 : 0

}

resource "aws_ssoadmin_managed_policy_attachment" "managed_policy" {
  for_each = toset(var.managed_policy_arn)

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  managed_policy_arn = each.value
}

resource "aws_ssoadmin_account_assignment" "assignement" {
  for_each = local.assignments

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn

  target_type = "AWS_ACCOUNT"
  target_id   = each.value.account_id

  principal_type = each.value.principal_type
  principal_id   = each.value.principal_id
}


locals {
  instance_arn = "arn:aws:sso:::instance/ssoins-66846c4ac9b86c19"

  assignments = {
    for pair in setproduct(var.account_ids, keys(var.principals)) :
    "${pair[0]}-${pair[1]}" => {
      account_id     = pair[0]
      principal_type = var.principals[pair[1]].type
      principal_id   = var.principals[pair[1]].id
    }
  }
}
