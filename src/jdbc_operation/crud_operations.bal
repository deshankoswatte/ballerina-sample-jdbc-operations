import ballerina/io;
import ballerinax/java.jdbc;

// JDBC Client for MySQL database. This client can be used with any JDBC
// supported database by providing the corresponding JDBC URL.
// jdbc:Client testDB = new ({
//    url: "jdbc:mysql://localhost:3306/demodb",
//    username: "root",
//    password: "password",
//    dbOptions: {useSSL: false}
// });

// JDBC Client for H2 database.
jdbc:Client testDB = new ({
    url: "jdbc:h2:file:./db_files/demodb",
    username: "test",
    password: "test"
});

public type Student record {
    int id?;
    string fullName?;
    int age?;
    string address?;
};

public function main() {
    createTable();
    insertStudent(1, "Dehami Koswatte", 20, "Homagama");
    insertStudent(2, "Vinula Buthgamumudalige", 20, "Dehiwala");
    insertStudent(3, "Sanjula Maddurapperuma", 20, "Rajagiriya");
    insertStudent(4, "Ihan Lelwala", 20, "Dehiwala");
}

public function createTable() {

    // Create the table.
    var ret = testDB->update("CREATE TABLE STUDENT (ID INTEGER, FULLNAME VARCHAR(50), AGE INTEGER, ADDRESS VARCHAR(100))");
    handleUpdate(ret, "Create STUDENT table");
}

public function getAllStudents() returns @tainted table<Student>{

    // Retrieving data from table.
    var selectRet = testDB->select("SELECT * FROM STUDENT", Student);
    if (selectRet is table<Student>) {
        return selectRet;   
    } else {
        error err = error("Record is nil");
        panic err;
    }
}

public function getStudent(int id) returns @tainted Student {

    // Retrieving data from table.
    Student student = {};
    var selectRet = testDB->select("SELECT * FROM STUDENT WHERE id = ?", Student, id);
    if (selectRet is table<Student>) {
        if (selectRet.hasNext()) {
            return selectRet.getNext();
        } else {
            return student;
        } 
    } else {
        panic error("Record is nil");
    }
}

public function insertStudent(int id, string fullName, int age, string address) {

    // Insert data row to the table
    var ret = testDB->update("INSERT INTO STUDENT (ID, FULLNAME, AGE, ADDRESS) VALUES (?, ?, ?, ?)", id, fullName, age, address);
    handleUpdate(ret, "Insert data to STUDENT table");
}

public function updateStudent(int id, string fullName, int age, string address) {

    // Update data row in the table
    var ret = testDB->update("UPDATE STUDENT SET fullName = ?, age = ?, address = ? WHERE ID = ?", fullName, age, address, id);
    handleUpdate(ret, "Update data in STUDENT table");
}

public function deleteStudent(int id) {

    // Delete data row in the table
    var ret = testDB->update("DELETE FROM STUDENT WHERE ID = ?", id);
    handleUpdate(ret, "Delete data in STUDENT table");    
}

public function truncateTable() {

    // Delete data row in the table
    var ret = testDB->update("TRUNCATE TABLE STUDENT");
    handleUpdate(ret, "Truncate STUDENT table");  
}

public function dropStudentTable() {

    // Drop the table
    var ret = testDB->update("DROP TABLE STUDENT");
    handleUpdate(ret, "Drop STUDENT table");  
}

function handleUpdate(jdbc:UpdateResult|jdbc:Error returned, string message) {

    if (returned is jdbc:UpdateResult) {
        io:println(message, " status: ", returned.updatedRowCount);
    } else {
        panic error(message + " failed: " + <string>returned.detail()?.message);
    }
}
