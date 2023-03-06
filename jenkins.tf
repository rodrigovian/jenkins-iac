module "jenkins_sg" {
    source = "terraform-aws-modules/security-group/aws"

    name                = "Jenkins-SG"
    description         = "Security group for jenkins instance"
    vpc_id              = "vpc-01093254c4e047a1c"

    ingress_cidr_blocks = ["0.0.0.0/0"]
    ingress_rules       = ["http-80-tcp"]
    egress_rules        = ["all-all"]
}
