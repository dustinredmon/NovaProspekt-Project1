#AWS s3 backend for terraform state 
terraform {
	backend  "s3" {
	region = "us-west-2"
	bucket = "novaprospekt-bucket"
	key = "terraform.tfstate"
	dynamodb_table = "tf-state-lock"    
	}
}

#AWS provider region
provider "aws" {
  region     = "us-west-2"
}

#AWS s3 bucket creation to store the terraform state files
resource "aws_s3_bucket" "tf-remote-state" {
  bucket = "novaprospekt-bucket"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "dynamodb-tf-state-lock" {
  name            = "tf-state-lock"
  hash_key        = "LockID"
  read_capacity   = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB tf state locking"
  }
}
