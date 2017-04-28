console.log('Loading function');
var AWS = require('aws-sdk');
var lambda = new AWS.Lambda();
exports.handler = function(event, context) {
    var functions = event.functions;
    for (var i in functions) {
        console.log("uploaded to lambda function: " + functions[i]);
        var params = {
            FunctionName: functions[i],
            S3Key: 'event-manager.zip',
            S3Bucket: 'latcraft-code'
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
};