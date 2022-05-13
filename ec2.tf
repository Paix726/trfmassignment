resource "aws_iam_user" "pooja" {
  name = "pooja"
}

resource "aws_iam_role" "pooja_role" {
  name = "pooja_role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}
resource "aws_iam_policy" "ec2pol" {
  #count = length(username)
  name   = "ec2pol"
  #path   = "/"
policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_policy_attachment" "ec2pol_role" {
  name  = "ec2_attachment"
  roles = [aws_iam_role.pooja_role.name]
  policy_arn = aws_iam_policy.ec2pol.arn
}
resource "aws_iam_instance_profile" "ec2prof" {
  name  = "ec2prof"
  role = aws_iam_role.pooja_role.name
}
resource "aws_instance" "my-instancep" {
  ami             = "ami-03a4a9b0b0197b758"
  instance_type   = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2prof.name
 # the Public SSH key
  key_name = "singapore-region-keypair"
associate_public_ip_address = true
tags = {
   Name = "server1"
}
}
