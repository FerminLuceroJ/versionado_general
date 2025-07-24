
# output "memorydb" {
#   value = module.memorydb
# }

output "aws_route53_record" {
  description = "Alias DNS Records"
  value       = { for k, v in aws_route53_record.memorydb : k => v.fqdn }

}