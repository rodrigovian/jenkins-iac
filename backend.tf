terraform {
  backend "s3" {
    bucket = "vian-vorx-terraform"
    key    = "jenkins-server.tfstate"
    region = "us-east-1"
  }
}
