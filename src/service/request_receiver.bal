import ballerina/http;
import ballerina/jsonutils;
import ballerina/io;
import jdbc_operation;

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

        table<record {}>|error allStudents = jdbc_operation:getAllStudents();
        http:Response response = new;

        if (allStudents is table<record {}>) {
            json retValJson = jsonutils:fromTable(allStudents);
            io:println("JSON: ", retValJson.toJsonString());

            response.setTextPayload(retValJson.toJsonString());
        } else {
            response.setPayload("Error in constructing a json from student!");
            response.statusCode = 500;
        }

        error? respond = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/getStudent/{studentId}"
    }
    resource function getStudent(http:Caller caller, http:Request req, int studentId) {

        jdbc_operation:Student|error student = jdbc_operation:getStudent(studentId);
        http:Response response = new;

        if (student is jdbc_operation:Student) {
            json|error retValJson = json.constructFrom(student);

            if (retValJson is json) {
                io:println("JSON: ", retValJson.toJsonString()); 
                response.setTextPayload(<@untained>  retValJson.toJsonString());  
            } else {
                response.setPayload("Error in constructing a json from student!");
                response.statusCode = 500;
            }
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
