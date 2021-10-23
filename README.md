# apigateway_test
Terraform API gateway / Lambda /DynamoDB
This Repo uses terraform to set up a simple API gateway integration with lambda and dynamodb on the backend

The following tasks are accomplished by the deployment

1: Create a DynamoDB table
  also populates with seed data using the script load.sh
  
2: Create a Lambda function
  with a nodejs handler that listens for specified routes
  
3: Create an HTTP API

4: Create routes
  "GET /items"
  "PUT /items"
  "GET /items/{id}
  "DELETE /items/{id}
  
Step 5: Create an integration
  Integration of API gateway with the created lambda functions 
  
Step 6: Attach your integration to routes
  Attach integrations to routes.
  
