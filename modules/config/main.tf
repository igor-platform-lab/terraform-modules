resource "aws_config_organization_managed_rule" "example" {
  region          = "us-east-2"
  name            = var.config_rule_name
  rule_identifier = var.rule
}
