terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {}

resource "aws_codecommit_repository" "dop_c02_01" {
  repository_name = "dop_c02_01"
  description     = "DOP-C02用リポジトリ"
}
