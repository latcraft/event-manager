
resource "aws_lambda_permission" "craftbot_function_api_gatewaypermission" {
  statement_id            = "AllowExecutionFromAPIGateway"
  action                  = "lambda:InvokeFunction"
  function_name           = "${aws_lambda_function.craftbot_function.arn}"
  qualifier               = "${aws_lambda_alias.craftbot_function_alias.name}"
  principal               = "apigateway.amazonaws.com"
  source_arn              = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.latcraft_api.id}/*/POST/${aws_api_gateway_resource.LatCraftAPICraftBot.path_part}"
}

resource "aws_api_gateway_resource" "LatCraftAPICraftBot" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  parent_id               = "${aws_api_gateway_rest_api.latcraft_api.root_resource_id}"
  path_part               = "craftbot"
}

resource "aws_api_gateway_method" "LatCraftAPICraftBotPOST" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "POST"
  authorization           = "NONE"
}

resource "aws_api_gateway_integration" "LatCraftAPICraftBotPOSTIntegration" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  credentials             = "${aws_iam_role.latcraft_api_executor.arn}"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.craftbot_function.function_name}/invocations"
  request_templates {
    "application/x-www-form-urlencoded" = <<EOF
## convert HTML POST data or HTTP GET query string to JSON

## get the raw post data from the AWS built-in variable and give it a nicer name
#if ($context.httpMethod == "POST")
 #set($rawAPIData = $input.path('$'))
#elseif ($context.httpMethod == "GET")
 #set($rawAPIData = $input.params().querystring)
 #set($rawAPIData = $rawAPIData.toString())
 #set($rawAPIDataLength = $rawAPIData.length() - 1)
 #set($rawAPIData = $rawAPIData.substring(1, $rawAPIDataLength))
 #set($rawAPIData = $rawAPIData.replace(", ", "&"))
#else
 #set($rawAPIData = "")
#end

## first we get the number of "&" in the string, this tells us if there is more than one key value pair
#set($countAmpersands = $rawAPIData.length() - $rawAPIData.replace("&", "").length())

## if there are no "&" at all then we have only one key value pair.
## we append an ampersand to the string so that we can tokenise it the same way as multiple kv pairs.
## the "empty" kv pair to the right of the ampersand will be ignored anyway.
#if ($countAmpersands == 0)
 #set($rawPostData = $rawAPIData + "&")
#end

## now we tokenise using the ampersand(s)
#set($tokenisedAmpersand = $rawAPIData.split("&"))

## we set up a variable to hold the valid key value pairs
#set($tokenisedEquals = [])

## now we set up a loop to find the valid key value pairs, which must contain only one "="
#foreach( $kvPair in $tokenisedAmpersand )
 #set($countEquals = $kvPair.length() - $kvPair.replace("=", "").length())
 #if ($countEquals == 1)
  #set($kvTokenised = $kvPair.split("="))
  #if ($kvTokenised[0].length() > 0)
   ## we found a valid key value pair. add it to the list.
   #set($devNull = $tokenisedEquals.add($kvPair))
  #end
 #end
#end

## next we set up our loop inside the output structure "{" and "}"
{
#foreach( $kvPair in $tokenisedEquals )
  ## finally we output the JSON for this pair and append a comma if this isn't the last pair
  #set($kvTokenised = $kvPair.split("="))
 "$util.urlDecode($kvTokenised[0])" : #if($kvTokenised[1].length() > 0)"$util.urlDecode($kvTokenised[1])"#{else}""#end#if( $foreach.hasNext ),#end
#end
}
EOF
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPICraftBotPOSTResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "200"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "LatCraftAPICraftBotPOSTError" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "500"
  response_models         = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "LatCraftAPICraftBotPOSTIntegrationResponse" {
  rest_api_id             = "${aws_api_gateway_rest_api.latcraft_api.id}"
  resource_id             = "${aws_api_gateway_resource.LatCraftAPICraftBot.id}"
  http_method             = "${aws_api_gateway_method.LatCraftAPICraftBotPOST.http_method}"
  status_code             = "200"
  depends_on              = [
    "aws_api_gateway_integration.LatCraftAPICraftBotPOSTIntegration"
  ]
}
