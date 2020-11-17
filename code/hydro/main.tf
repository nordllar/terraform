####################
## providers
####################
provider "aws" {
  region = "eu-west-1"
}

###################
## data sources
###################
data "archive_file" "unzipCopy_zip" {
  type = "zip"
  source_dir = "./functions/unzip_and_copy"
  output_path = "./functions/unzip_and_copy.zip"
}

##################
## Bucket
##################
resource "aws_s3_bucket" "hydro" {
  bucket = var.bucket_name
  acl = "private"

  tags = {
    Name = "hydro"
  }
}

resource "aws_s3_bucket_object" "folder" {
  count = length(var.s3_folders)
  bucket = aws_s3_bucket.hydro.id
  acl = "private"
  key = var.s3_folders[count.index]
  source = "/dev/null"
}

