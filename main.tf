provider "aws" {
  region = var.aws_region
}

#Configuração do Terraform State
terraform {
  backend "s3" {
    bucket = "terraform-state-soat"
    key    = "pedidos-infra-db/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-state-soat-locking"
    encrypt        = true
  }
}

### DynamoDB ###
resource "aws_dynamodb_table" "orders_table" {
  name           = "orders"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "order_id"
  range_key      = "client_id"

  attribute {
    name = "order_id"
    type = "S"
  }

  attribute {
    name = "client_id"
    type = "S"
  }

  global_secondary_index {
    name            = "ClientIdIndex"
    hash_key        = "client_id"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }
}