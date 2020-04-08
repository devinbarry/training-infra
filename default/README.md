# Training-Infra (Default)

Terraform code to ensure there exists both a default VPC and a default subnet with an
internet gateway.

Certain tasks make an assumption that both of these things exist and will fail
without them, for exaple: This setup is required for Packer.
