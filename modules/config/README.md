# Config: regra gerenciada da organização

## Propósito

Declarar uma regra gerenciada do AWS Config para a organização na região `us-east-2`, usando `aws_config_organization_managed_rule.example`.

## Uso pretendido

Consumir após a preparação da organização e dos pré-requisitos do AWS Config. O caller de referência é `terraform-management/management-security/30_config.tf`, em outro repositório; seus argumentos ainda precisam ser alinhados ao contrato abaixo.

## Recursos e comportamento

O módulo gerencia uma regra organizacional. Não cria a organização, contas, recorder, delivery channel, agregador, remediação ou SCP. A organização de destino é determinada pelo contexto da conta autenticada; o módulo não recebe um ID de organização.

## Inputs

| Nome | Tipo | Obrigatório | Finalidade |
| --- | --- | --- | --- |
| `config_rule_name` | `string` | Sim | Nome da regra organizacional. |
| `rule` | `string` | Sim | Identificador da regra gerenciada do AWS Config. |

## Outputs

Não declara outputs.

## Dependências e premissas

Requer Terraform, provider `hashicorp/aws`, credenciais de uma conta autorizada e os pré-requisitos de AWS Config/Organizations já configurados. A região está fixa no recurso em `us-east-2`; não há input `region`.

A organização deste projeto é gerenciada pelo bootstrap, em outro root e estado. A ordem entre essas execuções é operacional; uma variável com IDs não cria uma dependência Terraform entre estados. A referência inválida `depends_on = var.organization` e o input obrigatório `organization`, usado somente nessa referência, foram removidos.

## Exemplo

```hcl
module "versioned_bucket_config" {
  source = "./modules/config"

  config_rule_name = "versioned-bucket"
  rule             = "S3_BUCKET_VERSIONING_ENABLED"
}
```

O exemplo usa o caminho local a partir da raiz do repositório de módulos. Para consumo remoto, publique uma nova versão e fixe a referência correspondente; esta correção não altera a tag `config-v0.1.0`.

## Limitações e próximos passos

A regra avalia conformidade; não impede preventivamente a criação de buckets sem versionamento. O módulo não valida os nomes/identificadores fornecidos e não garante implantação dos pré-requisitos AWS. Chamadas não devem fornecer os antigos argumentos `organization`, nem `name`, `rule_identifier` ou `region`, que não são inputs deste módulo.

Depois do merge e da publicação de uma versão corrigida, atualize o `?ref=` do caller da management. A correção do módulo não altera automaticamente esse caller nem a configuração AWS.
