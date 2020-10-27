### site artifacts

data "archive_file" "lambda" {
  for_each = var.sites

  type        = "zip"
  source_dir  = each.value.source_dir
  output_path = each.value.output_path
}

### site lambdas

resource "aws_lambda_function" "lambda" {
  for_each = var.sites

  function_name = "${var.name}-${each.key}"

  filename         = data.archive_file.lambda[each.key].output_path
  source_code_hash = data.archive_file.lambda[each.key].output_base64sha256

  runtime = each.value.runtime
  handler = each.value.handler

  role = aws_iam_role.lambda.arn

  environment {
    variables = each.value.environment
  }

  vpc_config {
    subnet_ids         = var.vpc_private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }
}

### site lambda permissions

resource "aws_lambda_permission" "lambda_invoke_by_lb" {
  for_each = var.sites

  statement_id  = "${var.name}-${each.key}-invoke-by-lb"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lb[each.key].arn
}

### role

resource "aws_iam_role" "lambda" {
  name               = "${var.name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
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

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
