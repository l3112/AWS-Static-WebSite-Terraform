# actually not needed if you've done it in another file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0.0"
    }
  }
}
 

 provider "aws" {
  region = "us-east-2"
}
 /* 
 module "s3-website"{
     source = "./index.html"
 }
 output "site_endout" {
     value = "module.s3-website.site_endout"
 } */

resource "aws_s3_bucket" "staticsite" {
  bucket = "testbucketstatic"
  acl    = "public-read" //permissions

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}



resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.staticsite.bucket
  key          = "index.html"
  source       = "index.html" //they put theirs in a different folder. For testing purposes I don't
  content_type = "text/html"
  etag         = md5(file("index.html")) //the type of readability? I recognize md5 but that's in a cryptography context
  acl          = "public-read"
}


resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.staticsite.bucket
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  etag         = md5(file("index.html")) //oh it's object data?
  acl          = "public-read"
}