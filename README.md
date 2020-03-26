# Training-Infra

Terraform code to deploy DLR training infrastructure on AWS.


## Try to find AMI images

`aws ec2 describe-images --owners 099720109477 --filters "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64" "Name=description,Values=*18.04*"`
