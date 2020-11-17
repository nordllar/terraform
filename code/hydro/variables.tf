#############################
## varaibles
#############################


## S3 bucket ##
variable "bucket_name" {
  default = "nordllar-hydro"
}

variable "s3_folders" {
  type = list(string)
  description = "The list of S3 folders to create"
  default = ["upload", "raw", "preprocessed", "other"]
}