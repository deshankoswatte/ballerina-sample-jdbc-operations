# ballerina-boilerplate-jdbc-operations
Ballerina boilerplate code for database crud operations exposed as API endpoints using a ballerina service.

## Building and Testing out scenario

- Execute command `ballerina build -a` which will build all the modules.
- Navigate to `target/bin` using command `cd target/bin`.
- Run `manage_students.jar` using command `ballerina run manage_students.jar` which will create a table and insert some records into it.
- Then, run `student_service.jar` using command `ballerina run student_service.jar`which will run the service.
- Import the postman collection `student.postman_collection.json` located at `src/student_service/resources/student.postman_collection.json` and try out the requests by changing the parameters.