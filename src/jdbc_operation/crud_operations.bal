import ballerina/io;
import ballerinax/java.jdbc;

jdbc:Client testDB = new ({
    url: "jdbc:mysql://localhost:3306/testdb",
    username: "test",
    password: "test",
    dbOptions: {useSSL: false}
});

type Student record {
    int id;
    int age;
    string name;
};

public function main() {

    io:println("The update operation - Creating table and procedures:");
    var ret = testDB->update("CREATE TABLE student(id INT AUTO_INCREMENT, " +
        "age INT, name VARCHAR(255), PRIMARY KEY (id))");
    handleUpdate(ret, "Create student table");

    ret = testDB->update("CREATE PROCEDURE INSERTDATA(IN pAge INT, " +
        "IN pName VARCHAR(255)) " +
        "BEGIN " +
        "INSERT INTO student(age, name) VALUES (pAge, pName); " +
        "END");
    handleUpdate(ret, "Stored procedure with IN param creation");

    ret = testDB->update("CREATE PROCEDURE GETCOUNT (INOUT pID INT, " +
        "OUT pCount INT) " +
        "BEGIN " +
        "SELECT id INTO pID FROM student WHERE age = pID; " +
        "SELECT COUNT(*) INTO pCount FROM student " +
        "WHERE age = 20; " +
        "END");
    handleUpdate(ret, "Stored procedure with INOUT/OUT param creation");

    ret = testDB->update("CREATE PROCEDURE GETSTUDENTS() " +
        "BEGIN SELECT * FROM student; END");
    handleUpdate(ret, "Stored procedure with result set return");

    io:println("\nThe call operation - With IN params");

    var retCall = testDB->call("{CALL INSERTDATA(?,?)}", (), 20, "George");
    if (retCall is error) {
        io:println("Stored procedure call failed: ",
                    <string>retCall.detail()?.message);
    } else {
        io:println("Call operation with IN params successful");
    }

    io:println("\nThe call operation - With INOUT/OUT params");

    jdbc:Parameter pId = {
        sqlType: jdbc:TYPE_INTEGER,
        value: 20,
        direction: jdbc:DIRECTION_INOUT
    };
    jdbc:Parameter pCount = {
        sqlType: jdbc:TYPE_INTEGER,
        direction: jdbc:DIRECTION_OUT
    };

    retCall = testDB->call("{CALL GETCOUNT(?,?)}", (), pId, pCount);
    if (retCall is error) {
        io:println("Stored procedure call failed: ",
                    <string>retCall.detail()?.message);
    } else {
        io:println("Call operation with INOUT and OUT params successful");
        io:println("Student ID of the student with age of 20: ", pId.value);
        io:println("Student count with age of 20: ", pCount.value);
    }

    retCall = testDB->call("{CALL GETSTUDENTS()}", [Student]);
    if (retCall is error) {
        io:println("Stored procedure call failed: ",
                    <string>retCall.detail()?.message);

    } else if retCall is table<record {}>[] {
        table<Student> studentTable = retCall[0];
        io:println("Data in students table:");
        foreach var row in studentTable {
            io:println(row);
        }
    } else {
        io:println("Call operation is not returning data");
    }

    io:println("\nThe update operation - Drop the tables and procedures");
    ret = testDB->update("DROP TABLE student");
    handleUpdate(ret, "Drop table student");

    ret = testDB->update("DROP PROCEDURE INSERTDATA");
    handleUpdate(ret, "Drop stored procedure INSERTDATA");

    ret = testDB->update("DROP PROCEDURE GETCOUNT");
    handleUpdate(ret, "Drop stored procedure GETCOUNT");

    ret = testDB->update("DROP PROCEDURE GETSTUDENTS");
    handleUpdate(ret, "Drop stored procedure GETSTUDENTS");
}

function handleUpdate(jdbc:UpdateResult|jdbc:Error returned, string message) {
    if (returned is jdbc:UpdateResult) {
        io:println(message, " status: ", returned.updatedRowCount);
    } else {
        io:println(message, " failed: ", <string>returned.detail()?.message);
    }
}
