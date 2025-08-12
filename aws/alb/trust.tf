data "local_file" "ca_cert" {
  filename = var.ca_cert
}

resource "aws_s3_bucket" "ca_cert_bucket" {
  count = var.enable_mtls ? 1 : 0

  bucket = "${var.app_name}-ca-cert"
}

# Upload the certificate to the S3 bucket
resource "aws_s3_object" "ca_cert_object" {
  count = var.enable_mtls ? 1 : 0

  bucket  = aws_s3_bucket.ca_cert_bucket[0].id
  key     = "ca_bundle.pem"
  content = data.local_file.ca_cert.content
}

resource "aws_lb_trust_store" "main" {
  count = var.enable_mtls ? 1 : 0

  name                             = "${var.app_name}-trust-store"
  ca_certificates_bundle_s3_bucket = aws_s3_bucket.ca_cert_bucket[0].id
  ca_certificates_bundle_s3_key    = aws_s3_object.ca_cert_object[0].key
}