resource "aws_security_group" "port1" {
  name        = "port1"
  description = "Allow TLS inbound traffic"
  ingress {
    description      = "Allow internet from port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    #allow_all_outbound = false
   cidr_blocks = ["10.20.0.0/16"]
}
 ingress {
    description      = "Allow internet from port all"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    #allow_all_outbound = false
   cidr_blocks = ["0.0.0.0/0"]
}
 ingress {
    description      = "Allow internet from port 80"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    #allow_all_outbound = false
   cidr_blocks = ["10.20.0.0/16"]
}
#Outgoing traffic
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "my-instance" {
  ami             = "ami-03a4a9b0b0197b758"
  instance_type   = "t2.micro"
security_groups = ["port1"]
 # the Public SSH key
  key_name = "singapore-region-keypair"
associate_public_ip_address = true
tags = {
   Name = "pooja-trfm"
}
user_data = <<-EOF
               #!/bin/bash
               sudo apt-get update -y
               sudo apt-get install apache2 -y
               sudo mkfs -t ext4 /dev/xvdh
               sudo mount /dev/xvdh /var/www/html
               sudo git clone https://github.com/Paix726/images.git  /var/www/html
             EOF
}
resource "aws_ebs_volume" "poo-ebs" {
        availability_zone = aws_instance.my-instance.availability_zone
        size              = 8
}
resource "aws_volume_attachment" "pooja-ebs-attachment" {
        device_name = "/dev/sdh"
        volume_id = aws_ebs_volume.poo-ebs.id
        instance_id = aws_instance.my-instance.id
        force_detach = true
}
resource "aws_s3_bucket" "pooja" {
  bucket = "pooja-bucket1"
   acl   = "public-read"
tags = {
    Name        = "pooja-bucket1"
    Environment = "Dev"
  }
  provisioner "local-exec" {
    command = "git clone https://github.com/Paix726/images.git folder"
    }
  }
resource "aws_s3_bucket_object" "image_upload" {
  bucket = aws_s3_bucket.pooja.bucket
  key    = "pattern.png"
  source = "folder/pattern.png"
  acl = "public-read"
} 

