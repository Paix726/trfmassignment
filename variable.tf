variable "AWS_REGION" {    
    default = "ap-southeast-1"
}

variable "AMI" {
    type = map
    default = {
    ap-southeast-1 ="ami-03a4a9b0b0197b758"
    }
}
