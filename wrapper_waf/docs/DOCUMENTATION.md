# Documentation

## Introducción

El Wrapper de Terraform para WAF simplifica la configuración del Web Application Firewall en la nube de AWS. Este wrapper funciona como una plantilla predefinida, facilitando la creación y gestión de WAF al encargarse de todos los detalles técnicos.

**Diagrama** <br/>

A continuación se puede ver una imagen que muestra la totalidad de recursos que se pueden desplegar con el wrapper:

<center>![alt text](diagrams/main.png)</center>

---

## Modo de Uso
```hcl
    waf_parameters = {
        "exSimple" = {
            logging_enable = false
            rules = [
              {
                name                = "AWSManagedRulesCommonRuleSet-rule-1"
                priority            = "10"
                override_action     = "none"
                visibility_config   = {
                    metric_name     = "AWSManagedRulesCommonRuleSet-metric"
                }
                managed_rule_group_statement = {
                  name              = "AWSManagedRulesCommonRuleSet" //WCU 700
                  vendor_name       = "AWS"
                }
              }
            ]
        }
    }
```
<details>
<summary>Tabla de Variables</summary>

| Variable                     | Variable Description                        | Type     | Default                                                | Alternatives                  |
|------------------------------|---------------------------------------------|----------|--------------------------------------------------------|-------------------------------|
| logging_enable               | Whether Route53 zone is private or public   | `bool`   | `false`                                                | `true or false`               |
| enabled                      | List of objects of DNS records              | `bool`   | `true`                                                 | `true or false`               |
| scope                        | Set the scope of a resource                 | `string` | `REGIONAL`                                             | `CLOUDFRONT`                  |
| create_alb_association       | Create association to ALB                   | `bool`   | `false`                                                | `true or false`               |
| alb_arn                      | Specify the ALB ARN                         | `string` | ` `                                                    | ` `                           |
| allow_default_action         | Specify list of ALB ARNs                    | `[]`     | `[]`                                                   | `[]`                          |
| rules                        | Define the rules for the resource           | `[]`     | `[{ name = "disabled" }]`                              | `[]`                          |
| create_logging_configuration | create a log configuration                  | `bool`   | `false`                                                | `true or false`               |
| log_destination_configs      | Define destination settings for logs        | `[]`     | `[]`                                                   | `[]`                          |
| logging_filter               | Apply a log filter                          | `string` | `local.logging_filter_default`                         | ` `                           |


</details>
---