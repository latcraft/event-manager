console.log('Loading function');
var AWS = require('aws-sdk');
var lambda = new AWS.Lambda();
exports.handler = function(event, context) {
    key = event.Records[0].s3.object.key
    bucket = event.Records[0].s3.bucket.name
    if (key == 'event-manager.zip' && bucket == 'latcraft-code') {
        var functions = [
            "publish_cards_function"
        ];
        for (var i in functions) {
            console.log("uploaded to lambda function: " + functions[i]);
            var params = {
                FunctionName: functions[i],
                S3Key: key,
                S3Bucket: bucket
            };
            lambda.updateFunctionCode(params, function (err, data) {
                if (err) {
                    console.log(err, err.stack);
                    context.fail(err);
                } else {
                    console.log(data);
                    context.succeed(data);
                }
            });
        }
    } else {
        context.succeed("skipping " + key + " in bucket " + bucket );
    }
};