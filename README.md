# ballerina-boilerplate-jdbc-operations
Ballerina boilerplate code for database crud operations exposed as API endpoints using a ballerina service.

## Building and Testing out scenario

- Execute command `ballerina build -a` which will build all the modules.
- Navigate to `target/bin` using command `cd target/bin`.
- Run `jdbc_operation.jar` using command `ballerina run jdbc_operation.jar` which will create a table and insert some records into it.
- Then, run `http_service.jar` using command `ballerina run http_service.jar`which will run the service.
- Import the postman collection `student.postman_collection.json` located at `src/http_service/resources/student.postman_collection.json` and try out the requests by changing the parameters.