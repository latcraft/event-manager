
resource "aws_api_gateway_deployment" "latcraft_api_deployment" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  stage_name              = "prod"
  stage_description       = "${timestamp()}" // forces to 'create' a new deployment each run
}

resource "aws_api_gateway_usage_plan" "latcraft_api_usage_plan" {

  name         = "latcraft-api-usage-plan"
  description  = "my description"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.latcraft_api.id}"
    stage  = "${aws_api_gateway_deployment.latcraft_api_deployment.stage_name}"
  }

  quota_settings {
    limit  = 200
    period = "DAY"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }

}

resource "aws_api_gateway_api_key" "latcraft_api_key" {
  name                    = "latcraft_api_key"
  description             = "Default LatCraft API key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.latcraft_api_key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.latcraft_api_usage_plan.id}"
}
