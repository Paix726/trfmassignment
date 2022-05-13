resource "aws_s3_bucket" "tf-bucket"{
  bucket = "pooja-tf-bucket"
  tags = {
    Name = "S3Bucket"
  }
}
