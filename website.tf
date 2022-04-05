variable "website_root" {
  type        = string
  description = "Path to the root of website content"
  default     = "./src"
}

resource "aws_s3_bucket" "my_static_website" {
  bucket = "blog-example-m9wtv64y"
  acl    = "private"

  website {
    index_document = "index.html"
  }
}


locals {
  website_files = fileset(var.website_root, "**")

  file_hashes = {
    for filename in local.website_files :
    filename => filemd5("${var.website_root}/${filename}")
  }

  mime_types = jsondecode(file("mime.json"))
}


resource "aws_s3_bucket_object" "file" {
  for_each = local.website_files

  bucket       = aws_s3_bucket.my_static_website.id
  key          = each.key
  source       = "${var.website_root}/${each.key}"
  source_hash  = local.file_hashes[each.key]
  acl          = "public-read"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

output "website_endpoint" {
  value = aws_s3_bucket.my_static_website.website_endpoint
}
