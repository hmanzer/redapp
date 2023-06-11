#####
# S3 backend bucket
#####
resource "aws_s3_bucket" "terraform_s3_backend_main" {
  bucket = var.bucket_name
  tags = {
    Name        = var.bucket_name
    environment = var.env
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_s3_backend_main" {
  bucket = aws_s3_bucket.terraform_s3_backend_main.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.terraform_s3_backend_main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_s3_backend_main" {
  bucket = aws_s3_bucket.terraform_s3_backend_main.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_versioning" "terraform_s3_backend_main" {
  bucket = aws_s3_bucket.terraform_s3_backend_main.id

  versioning_configuration {
    status = "Enabled"
  }
}

#####
# DynamoDB state locking
#####
resource "aws_dynamodb_table" "terraform_state_lock_main" {
  name           = var.lock_table_name
  read_capacity  = 5
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

