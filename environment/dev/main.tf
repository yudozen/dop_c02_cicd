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

module "codebuild" {
    source = "../../module/codebuild"
    codecommit_arn = module.codecommit.arn
    codecommit_clone_url_http = module.codecommit.clone_url_http
    ecr_repository_url = module.ecr.repository_url
}

module "codepipeline" {
    source = "../../module/codepipeline"
    codecommit_arn = module.codecommit.arn
    codecommit_repository_name = module.codecommit.repository_name
    codebuild_name = module.codebuild.name
}

