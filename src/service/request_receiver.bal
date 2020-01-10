import ballerina/http;
import ballerina/log;
import ballerina/mime;

http:Client clientEP = new("http://localhost:9090");

@http:ServiceConfig {
    basePath: "/student"
}

service studentService on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/insertStudent"
    }
    resource function insertStudent(http:Caller caller, http:Request
                                        request) {

        http:Response response = new;

        var bodyParts = request.getBodyParts();
        if (bodyParts is mime:Entity[]) {
            foreach var part in bodyParts {
                handleContent(part);
            }
            response.setPayload(<@untainted> bodyParts);
        } else {
            log:printError(<string> bodyParts.reason());
            response.setPayload("Error in decoding multiparts!");
            response.statusCode = 500;
        }
        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error sending response", err = result);
        }
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/updateStudent"
    }
    resource function updateStudent(http:Caller caller, http:Request
                                        request) {
                                            
        http:Response response = new;

        var bodyParts = request.getBodyParts();
        if (bodyParts is mime:Entity[]) {
            foreach var part in bodyParts {
                handleContent(part);
            }
            response.setPayload(<@untainted> bodyParts);
        } else {
            log:printError(<string> bodyParts.reason());
            response.setPayload("Error in decoding multiparts!");
            response.statusCode = 500;
        }
        var result = caller->respond(response);
        if (result is error) {
            log:printError("Error sending response", err = result);
        }
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/encode"
    }
    resource function multipartSender(http:Caller caller, http:Request req) {

        mime:Entity jsonBodyPart = new;
        jsonBodyPart.setContentDisposition(
                        getContentDispositionForFormData("json part"));
        jsonBodyPart.setJson({"name": "wso2"});

        mime:Entity xmlFilePart = new;
        xmlFilePart.setContentDisposition(
                       getContentDispositionForFormData("xml file part"));

        xmlFilePart.setFileAsEntityBody("./files/test.xml",
                                        contentType = mime:APPLICATION_XML);

        mime:Entity[] bodyParts = [jsonBodyPart, xmlFilePart];
        http:Request request = new;

        request.setBodyParts(bodyParts, contentType = mime:MULTIPART_FORM_DATA);
        var returnResponse = clientEP->post("/multiparts/decode", request);
        if (returnResponse is http:Response) {
            var result = caller->respond(returnResponse);
            if (result is error) {
                log:printError("Error sending response", err = result);
            }
        } else {
            http:Response response = new;
            response.setPayload("Error occurred while sending multipart " +
                                    "request!");
            response.statusCode = 500;
            var result = caller->respond(response);
            if (result is error) {
                log:printError("Error sending response", err = result);
            }
        }
    }
}

function handleContent(mime:Entity bodyPart) {
    var mediaType = mime:getMediaType(bodyPart.getContentType());
    if (mediaType is mime:MediaType) {
        string baseType = mediaType.getBaseType();
        if (mime:APPLICATION_XML == baseType || mime:TEXT_XML == baseType) {

            var payload = bodyPart.getXml();
            if (payload is xml) {
                log:printInfo(payload.toString());
            } else {
                log:printError(<string> payload.detail().message);
            }
        } else if (mime:APPLICATION_JSON == baseType) {

            var payload = bodyPart.getJson();
            if (payload is json) {
                log:printInfo(payload.toJsonString());
            } else {
                log:printError(<string> payload.detail().message);
            }
        } else if (mime:TEXT_PLAIN == baseType) {

            var payload = bodyPart.getText();
            if (payload is string) {
                log:printInfo(payload);
            } else {
                log:printError(<string> payload.detail().message);
            }
        }
    }
}

function getContentDispositionForFormData(string partName)
                                    returns (mime:ContentDisposition) {
    mime:ContentDisposition contentDisposition = new;
    contentDisposition.name = partName;
    contentDisposition.disposition = "form-data";
    return contentDisposition;
}
