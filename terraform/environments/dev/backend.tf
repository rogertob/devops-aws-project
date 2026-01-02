terraform {
  backend "s3" {
    bucket       = "devops-aws-project-tfstate-dev"
    key          = "env/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}