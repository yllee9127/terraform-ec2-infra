terraform {
  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key = "yl-ce8.tfstate"
    region = "ap-southeast-1"
  }
}