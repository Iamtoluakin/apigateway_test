
output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.dynamodb.function_name
}

output "stage_url" {
  value = {for k, v in aws_apigatewayv2_stage.project: k => v.invoke_url}
}

