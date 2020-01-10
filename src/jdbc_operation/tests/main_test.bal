import ballerina/io;
import ballerina/test;

# Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

# Before test function

function beforeFunc() {
    io:println("\nCreate the STUDENT table before function\n");
    createTable();
}

# Test function

@test:Config {
    before: "beforeFunc"
}
function testInsertion() {

    io:println("Running function testInsertion");
    io:println("====================================================================");
    io:println("Adding data into the STUDENT table");
    insertStudent(1, "Dehami Koswatte", 20, "Homagama");
    insertStudent(2, "Vinula Buthgamumudalige", 20, "Dehiwala");
    insertStudent(3, "Sanjula Maddurapperuma", 20, "Rajagiriya");
    insertStudent(4, "Ihan Lelwala", 20, "Dehiwala");
    insertStudent(5, "Shenal Mendis", 20, "Kottawa");

    io:println("\nTesting whether records are added to the STUDENT table\n");
    test:assertTrue(getStudent(1)?.id == 1, msg = "Student with id 1 not found!");
    test:assertTrue(getStudent(2)?.id == 2, msg = "Student with id 2 not found!");
    test:assertTrue(getStudent(3)?.id == 3, msg = "Student with id 3 not found!");
    test:assertTrue(getStudent(4)?.id == 4, msg = "Student with id 4 not found!");
    test:assertTrue(getStudent(5)?.id == 5, msg = "Student with id 5 not found!");
}

# Test function

@test:Config {
    dependsOn: ["testInsertion"]
}
function testRetrieval() {

    io:println("Running function testRetrieval");
    io:println("====================================================================");
    io:println("Retrieving a persisted student");
    test:assertTrue(getStudent(1)?.id == 1, msg = "Student with id 1 not found!");
    
    io:println("\nRetrieving a non-persisted student\n");
    test:assertTrue(getStudent(8)?.id != 8, msg="Student with id 8 should have not be found!");
}

# Test function

@test:Config {
    dependsOn: ["testRetrieval"]
}
function testUpdation() {

    io:println("Running function testUpdation");
    io:println("====================================================================");
    io:println("Updating data in the STUDENT table");
    updateStudent(1, "Dehami Koswatte", 30, "Homagama");

    io:println("\nTesting whether records are updated in the STUDENT table\n");
    test:assertTrue(getStudent(1)?.age == 30, msg = "Student with id 1 has not been updated!");
}

# Test function

@test:Config {
    dependsOn: ["testUpdation"],
    after: "afterFunc"
}
function testDeletion() {

    io:println("Running function testInsertion");
    io:println("====================================================================");
    io:println("Deleting data in the STUDENT table");
    deleteStudent(1);

    io:println("\nTesting whether records are updated in the STUDENT table\n");
    test:assertTrue(getStudent(1)?.id != 1, msg = "Student with id 1 has not been deleted!");
}

# After test function

function afterFunc() {
    
    io:println("Droping the STUDENT table after function\n");
    dropStudentTable();
}

# After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
