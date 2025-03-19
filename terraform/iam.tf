
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "dae_codeathon_test_role_glue" {
    name = "dae_codeathon_test_role_glue"
    assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy.json
    max_session_duration = 12 * 60 * 60
}

resource "aws_iam_role" "dae_codeathon_test_role_ecs" {
    name = "dae_codeathon_test_role_ecs"
    assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role" "dae_lambda_test_role" {

  name = "dae_lambda_test_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}





