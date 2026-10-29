# Permission set do IAM Identity Center

## Objetivo

Configurar um permission set em uma instância existente do IAM Identity Center e atribuí-lo às combinações de contas e principals fornecidas pelo caller.

## Uso pretendido

Use em um root de administração do Identity Center. A região e as credenciais do provider devem permitir administrar a instância configurada no módulo. Não existe caller neste repositório de módulos; o uso depende do root consumidor.

## Recursos e comportamento

- `aws_ssoadmin_permission_set.permission_set`: cria o permission set com sessão de duas horas.
- `aws_ssoadmin_permission_set_inline_policy.inline_policy`: associa uma inline policy quando `inline_policy` não é `null`.
- `aws_ssoadmin_managed_policy_attachment.managed_policy`: associa as policies gerenciadas pela AWS informadas, eliminando ARNs duplicados com `toset`.
- `aws_ssoadmin_account_assignment.assignement`: cria um assignment para cada combinação de conta e chave do mapa de principals.

O ARN da instância está fixado em `local.instance_arn`, no [main.tf](main.tf). Os assignments concedem acesso conforme as policies; o módulo não cria limites SCP ou controles de rede.

## Inputs

| Nome | Tipo | Obrigatório | Finalidade |
| --- | --- | --- | --- |
| `name` | `string` | Sim | Nome do permission set |
| `inline_policy` | `string` | Não; padrão `null` | Documento JSON de permissões |
| `managed_policy_arn` | `list(string)` | Não; padrão `[]` | ARNs de policies gerenciadas pela AWS |
| `account_ids` | `set(string)` | Sim | Contas que receberão os assignments |
| `principals` | `map(object({ type = string, id = string }))` | Sim | Principals existentes; use `USER` ou `GROUP` no tipo e o ID do Identity Center |

É necessário informar uma lista não vazia de managed policies ou uma inline policy não nula. O módulo não valida o conteúdo JSON nem se os tipos/IDs de principals existem. Conjuntos de contas ou principals vazios não produzem assignments.

## Outputs

O módulo não declara outputs.

## Dependências e premissas

O caller fornece o provider AWS. A instância, as contas e os usuários/grupos devem existir previamente. O ARN fixo precisa corresponder à instância administrada; o módulo não é reutilizável em outra instância sem alterar esse local.

A validação de `managed_policy_arn` referencia outra variável, exigindo Terraform >= 1.9; essa exigência não está declarada em `required_version` no módulo. Policies e assignments dependem do permission set por referência ao ARN, mas não há ordenação explícita dos assignments após os attachments das policies.

## Exemplo

Exemplo local; substitua os marcadores por identificadores reais e configure o provider no root:

```hcl
module "permission_set" {
  source = "./modules/permission_set"

  name               = "ReadOnly"
  managed_policy_arn = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  account_ids        = ["<account-id>"]
  principals = {
    readers = {
      type = "GROUP"
      id   = "<identity-center-group-id>"
    }
  }
}
```

Após uma release, o consumidor pode usar `git::https://github.com/<owner>/<repo>.git//modules/permission_set?ref=permission_set-v<versão>`. Use uma tag efetivamente publicada.

## Limitações

O módulo não cria contas, a instância do Identity Center, usuários, grupos ou integração Entra/SAML/SCIM. Não configura customer managed policy attachments, session duration parametrizável ou acesso Kubernetes. A configuração local e o cadastro no Release Please não confirmam implantação na AWS. Consulte o [guia de releases](../../docs/release-please.md) para publicação e atualização do consumidor.
