terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

module "codecommit" {
  source = "../../module/codecommit"

  # モジュールに渡す変数（必要に応じて）
  # variable1 = "value1"
  # variable2 = "value2"
}

module "ecr" {
  source = "../../module/ecr"
}
