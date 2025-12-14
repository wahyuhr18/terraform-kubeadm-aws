output "vpc_id" {
  description = "VPC ID dari homelab"
  value       = aws_vpc.homelab.id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List ID dari public subnet"
  value       = [for subnet in values(aws_subnet.public) : subnet.id]
}

output "private_subnet_ids" {
  description = "List ID dari private subnet"
  value       = [for subnet in values(aws_subnet.private) : subnet.id]
}