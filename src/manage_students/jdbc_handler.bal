import ballerina/io;
import ballerinax/java.jdbc;

// JDBC Client for MySQL database. This client can be used with any JDBC
// supported database by providing the corresponding JDBC URL.
jdbc:Client testDB = new ({
   url: "jdbc:mysql://localhost:3306/demodb",
   username: "user",
   password: "password",
   dbOptions: {useSSL: false}
});

// JDBC Client for H2 database.
// jdbc:Client testDB = new ({
//     url: "jdbc:h2:file:./db_files/demodb",
//     username: "test",
//     password: "test"
// });

# 
# Main function to be executed, helps in create a 
# table and add sample data for testing purposes.
# 
public function main() {

    boolean|error createdTableStatus = createTable();

    // Used for testing purposes.
    boolean|error student_1_InsertionStatus = insertStudent(1, "Dehami Koswatte", 20, "Homagama");
    boolean|error student_2_InsertionStatus = insertStudent(2, "Vinula Buthgamumudalige", 20, "Dehiwala");
    boolean|error student_3_InsertionStatus = insertStudent(3, "Sanjula Maddurapperuma", 20, "Rajagiriya");
    boolean|error student_4_InsertionStatus = insertStudent(4, "Ihan Lelwala", 20, "Dehiwala");
}

# 
# Function used to create the students table.
# 
# + return - Boolean true if table is created, error if not.
public function createTable() returns @tainted boolean|error{

    // Create the student table.
    var dbResult = testDB->update("CREATE TABLE STUDENTS (id INTEGER, fullname VARCHAR(50), age INTEGER, address VARCHAR(100), PRIMARY KEY (id))");
    // Check status of the table creation.
    error|boolean dbStatus = processUpdate(dbResult, "Create STUDENTS table");

    return dbStatus;
}

# 
# Extract all the students from the table.
# 
# + return - Table of students if available, else an error representing the cause.
public function getAllStudents() returns @tainted table<Student>|error{

    // Retrieving all the students from the table.
    var dbResult = testDB->select("SELECT * FROM STUDENTS", Student);
    // Check if the result is valid.
    if (dbResult is table<Student>) {
        // Check if there is data.
        if (dbResult.hasNext()) {
            return dbResult;
        } else {
            return error("No students are persisted in the database.");
        }  
    } else {
        return error("Corrupted data extracted from database.");
    }
}

# 
# Extract a student from the db given the student id.
# 
# + id     - id Parameter: Id of the student.
# + return - Student if avaliable, else an error representing the cause.
public function getStudent(int id) returns @tainted Student|error {

    // Retrieving data from table.
    var dbResult = testDB->select("SELECT * FROM STUDENTS WHERE id = ?", Student, id);
    // Check if the result is valid.
    if (dbResult is table<Student>) {
        // Check if there is data.
        if (dbResult.hasNext()) {
            return dbResult.getNext();
        } else {
            return error("Student cannot be extracted with the given id.");
        } 
    } else {
        return error("Corrupted data extracted from database.");
    }
}

# 
# Insert a student record to the students table.
# 
# + id       - id Parameter: Id of the student. 
# + fullName - fullName Parameter: Fullname of the student.
# + age      - age Parameter: Age of the student.
# + address  - address Parameter: Address of the student.
# + return   - Boolean true if the insertion is successful, error if else.
public function insertStudent(int id, string fullName, int age, string address) returns @tainted boolean|error{

    // Insert a student to the table
    var dbResult = testDB->update("INSERT INTO STUDENTS (id, fullName, age, address) VALUES (?, ?, ?, ?)", id, fullName, age, address);
    error|boolean dbStatus = processUpdate(dbResult, "Insert data to STUDENTS table");

    return dbStatus;
}

# 
# Update a student record in the students table.
# 
# + id       - id Parameter: Id of the student. 
# + fullName - fullName Parameter: Fullname of the student.
# + age      - age Parameter: Age of the student.
# + address  - address Parameter: Address of the student.
# + return   - Boolean true if the updation is successful, error if else.
public function updateStudent(int id, string fullName, int age, string address) returns @tainted boolean|error{

    // Update data row in the table
    var dbResult = testDB->update("UPDATE STUDENTS SET fullName = ?, age = ?, address = ? WHERE ID = ?", fullName, age, address, id);
    error|boolean dbStatus = processUpdate(dbResult, "Update data in STUDENTS table");

    return dbStatus;
}

# 
# Delete a student record from the students table.
#
# + id     - id Parameter: Id of the student.
# + return - Boolean true if the deletion is successful, error if else.
public function deleteStudent(int id) returns @tainted boolean|error{

    // Delete data row in the table
    var dbResult = testDB->update("DELETE FROM STUDENTS WHERE id = ?", id);
    error|boolean dbStatus = processUpdate(dbResult, "Delete data in STUDENTS table");    
        
    return dbStatus;
}

# 
# Truncate the students table.
#
# + return - Boolean true if the truncation is successful, error if else.
public function truncateTable() returns @tainted boolean|error{

    // Delete data row in the table
    var dbResult = testDB->update("TRUNCATE TABLE STUDENTS");
    error|boolean dbStatus = processUpdate(dbResult, "Truncate STUDENTS table"); 

    return dbStatus;
}

# 
# Drop the students table.
#
# + return - Boolean true if the table is dropped successfully, error if else.
public function dropTable() returns @tainted boolean|error{

    // Drop the table
    var dbResult = testDB->update("DROP TABLE STUDENTS");
    error|boolean dbStatus = processUpdate(dbResult, "Drop STUDENTS table");

    return dbStatus;  
}

# 
# Process a request specified for an update query.
# 
# + returned - returned Parameter: Result from db.
# + message  - message Parameter: Custom message for the process. 
# + return   - Boolean true if the update is processed successfully, error if else.
function processUpdate(jdbc:UpdateResult|jdbc:Error returned, string message) returns error|boolean{

    if (returned is jdbc:UpdateResult) {
        io:println(message, " status: ", returned.updatedRowCount);
        return true;
    } else {
        io:println(message, " failed: " + <string>returned.detail()?.message);
        return error(message + " failed: " + <string>returned.detail()?.message);
    }
}
