const response = process.env.RESPONSE;

exports.handler = async function (event, context) {
    return {
        "statusCode":        200,
        "statusDescription": "200 OK",
        "isBase64Encoded":   false,
        "headers":           {
            "Content-Type": "text/plain"
        },
        "body":              response
    }
}
