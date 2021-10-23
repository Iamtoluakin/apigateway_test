
resource "aws_iam_role" "project" {
  name = "${terraform.workspace}-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
    EOF
}

resource "aws_iam_role_policy" "project" {
  name   = "${terraform.workspace}-lambda"
  role   = "${aws_iam_role.project.id}"
  policy = "${file("${path.module}/templates/iam.json")}"
}
