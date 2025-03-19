data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./lambda_function/lambda_function.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role = aws_iam_role.dae_lambda_test_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}


data "aws_lambda_layer_version" "existing" {
    layer_name = "requests_layer"
    compatible_runtime = "python3.12"
}

resource "aws_lambda_function" "dae-lambda-function" {

  filename      = "./lambda_function_payload.zip"
  function_name = "dae_codeathon_test_function"
  role = aws_iam_role.dae_lambda_test_role.arn
  handler = "lambda_handler"
  layers =  [data.aws_lambda_layer_version.existing.arn]
  runtime = "python3.12"

}


# layer for lambda
