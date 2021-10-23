resource "aws_dynamodb_table_item" "project" {
  table_name = aws_dynamodb_table.project.name
  hash_key   = aws_dynamodb_table.project.hash_key

  item = <<ITEM
{
  "id": {"S": "1"},
  "Name": {"S": "Ola"},
  "State": {"S": "Minnesota"}
}
ITEM
}

resource "aws_dynamodb_table" "project" {
  name           = "${terraform.workspace}-project"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  provisioner "local-exec" {
    command = "bash templates/load.sh"
  }

}
