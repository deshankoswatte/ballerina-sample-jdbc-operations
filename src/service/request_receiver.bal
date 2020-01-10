import ballerina/http;
import ballerina/jsonutils;
import ballerina/io;
import dehami/jdbc_operation;

http:Client clientEP = new("http://localhost:9090");

@http:ServiceConfig {
    basePath: "/student"
}

service studentService on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getAllStudents"
    }
    resource function getAllStudents(http:Caller caller, http:Request req) {

        table<record {}> tb = jdbc_operation:getAllStudents();

        json retValJson = jsonutils:fromTable(tb);
        io:println("JSON: ", retValJson.toJsonString());

        http:Response response = new;
        response.setTextPayload(retValJson.toJsonString());

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getStudent/{studentId}"
    }
    resource function getStudent(http:Caller caller, http:Request req, int studentId) {

        jdbc_operation:Student student = jdbc_operation:getStudent(studentId);

        json|error retValJson = json.constructFrom(student);

        http:Response response = new;

        if (retValJson is json) {
            io:println("JSON: ", retValJson.toJsonString()); 
            response.setTextPayload(<@untained>  retValJson.toJsonString());  
        } else {
            response.setPayload("Error in constructing a json from student!");
            response.statusCode = 500;
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/insertStudent"
    }
    resource function insertStudent(http:Caller caller, http:Request
                                        request) {

        
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/updateStudent"
    }
    resource function updateStudent(http:Caller caller, http:Request
                                        request) {
                                            

    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/deleteStudent"
    }
    resource function deleteStudent(http:Caller caller, http:Request req) {


    }
}
