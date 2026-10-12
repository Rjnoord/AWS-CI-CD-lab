terraform {
  backend "s3" {
    bucket       = "rjnoord-terraform-state"
    key          = "aws-ci-cd-lab/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}