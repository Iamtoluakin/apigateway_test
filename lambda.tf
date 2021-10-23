data "archive_file" "dynamodb" {
  type        = "zip"
  source_file = "${path.module}/templates/index.js"
  output_path = "${path.module}/templates/index.zip"
}

resource "aws_lambda_function" "dynamodb" {
  filename         = "${data.archive_file.dynamodb.output_path}"
  function_name    = "dynamodb_calls"
  description      = "apigateway-lambda-dynamo"
  role             = aws_iam_role.project.arn
  handler          = "index.handler"
  source_code_hash = "{data.archive_file.dynamodb.output_base64sha256}"
  runtime          = "nodejs14.x"
  timeout          = 80

  environment {
    variables = {
       DYNAMODB_TABLE = aws_dynamodb_table.project.name
    }
  }

}

