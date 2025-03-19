resource "aws_s3_bucket" "dae_codeathon_test_bucket"{
    bucket = "dae-codeathon-bucket"
    force_destroy = true
}



data "aws_iam_policy_document" "dae_s3_policy"{
  
  statement {
    effect = "Allow"
    actions = ["s3:*", "s3-object-lambda:*"]
    resources = [aws_s3_bucket.dae_codeathon_test_bucket.arn]

  }
  
}

resource "aws_iam_policy" "s3_policy"{
  name = "dae_s3_codeathon_s3_policy"
  description = "dae_s3_policy"
  policy = data.aws_iam_policy_document.dae_s3_policy.json
}


resource "aws_iam_role_policy_attachment" "s3_attach" {
  role = aws_iam_role.dae_codeathon_test_role_ecs.name
  policy_arn = aws_iam_policy.s3_policy.arn
}