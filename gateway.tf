locals {
  http_root_route = toset([
    "GET /items",
    "PUT /items"
  ])
}

locals {
  http_child_route = toset([
    "GET /items/{id}",
    "DELETE /items/{id}" 
  ])
}


locals {
  stages = toset([
    "dev",
    "prod",
  ])
}

resource "aws_apigatewayv2_api" "project" {
  name          = "${terraform.workspace}-project"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "project" {
  for_each    = local.stages
  api_id      = aws_apigatewayv2_api.project.id
  name        = each.key
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "project" {
  api_id = aws_apigatewayv2_api.project.id
  payload_format_version = "2.0"

  integration_uri    = aws_lambda_function.dynamodb.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}


resource "aws_apigatewayv2_route" "root" {
  for_each = local.http_root_route
  api_id = aws_apigatewayv2_api.project.id

  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.project.id}"
}

resource "aws_apigatewayv2_route" "child" {
  for_each = local.http_child_route
  api_id = aws_apigatewayv2_api.project.id

  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.project.id}"

  depends_on  = [
      aws_apigatewayv2_route.root       
      ]

}

# This lambda permission allows the API Gateway to invoke the lambda it's integrated with
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "${terraform.workspace}_AllowExecutionFromAPI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dynamodb.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.project.execution_arn}/*/*/*"
}

## create a cloudwatch group for logging 
# Set retention on cloudwatch logs for API log group to the specified number of days.
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  for_each          = local.stages
  name              = "API-Gateway-Execution-Logs_${aws_apigatewayv2_api.project.id}/${each.key}"
  retention_in_days = var.log_retention_in_days
}
