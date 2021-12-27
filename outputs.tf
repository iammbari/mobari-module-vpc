
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

 output "primary_subnet_ids" {
   value = aws_subnet.primary.*.id
 }
output "secondary" {
  value = aws_subnet.secondary.*.id
}
output "secondary_subnet_ids" {
  value = aws_subnet.secondary.*.id
}

output "tertiary_subnet_ids" {
  value = aws_subnet.tertiary.*.id
}