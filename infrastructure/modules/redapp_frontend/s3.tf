resource "aws_s3_bucket" "s3_frontend_artifacts" {
  bucket = var.s3_frontend_artifacts_bucket_name

  tags = {
    Name        = var.s3_frontend_artifacts_bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_frontend_artifacts" {
  bucket = aws_s3_bucket.s3_frontend_artifacts.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}
