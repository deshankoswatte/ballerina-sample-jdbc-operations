import ballerina/io;
import ballerina/test;

# Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

# Before test function

function beforeFunc() {
    io:println("\nCreate the STUDENTS table before function\n");
    boolean|error tableCreationStatus = createTable();
}

# Test function

@test:Config {
    before: "beforeFunc"
}
function testInsertion() {

    io:println("Running function testInsertion");
    io:println("====================================================================");
    io:println("Adding data into the STUDENTS table");

    boolean|error student_1_InsertionStatus = insertStudent(1, "Dehami Koswatte", 20, "Homagama");
    boolean|error student_2_InsertionStatus = insertStudent(2, "Vinula Buthgamumudalige", 20, "Dehiwala");
    boolean|error student_3_InsertionStatus = insertStudent(3, "Sanjula Maddurapperuma", 20, "Rajagiriya");
    boolean|error student_4_InsertionStatus = insertStudent(4, "Ihan Lelwala", 20, "Dehiwala");
    boolean|error student_5_InsertionStatus = insertStudent(5, "Shenal Mendis", 20, "Kottawa");

    io:println("\nTesting whether records are added to the STUDENTS table\n");
    test:assertTrue(getStudent(1) is Student, msg = "Student with id 1 not found!");
    test:assertTrue(getStudent(2) is Student, msg = "Student with id 2 not found!");
    test:assertTrue(getStudent(3) is Student, msg = "Student with id 3 not found!");
    test:assertTrue(getStudent(4) is Student, msg = "Student with id 4 not found!");
    test:assertTrue(getStudent(5) is Student, msg = "Student with id 5 not found!");
}

# Test function

@test:Config {
    dependsOn: ["testInsertion"]
}
function testRetrieval() {

    io:println("Running function testRetrieval");
    io:println("====================================================================");
    io:println("Retrieving a persisted student");
    test:assertTrue(getStudent(1) is Student, msg = "Student with id 1 not found!");
    
    io:println("\nRetrieving a non-persisted student\n");

    test:assertTrue(getStudent(8) is error, "Student with id 8 should have not be found");
}

# Test function

@test:Config {
    dependsOn: ["testRetrieval"]
}
function testUpdation() {

    io:println("Running function testUpdation");
    io:println("====================================================================");
    io:println("Updating data in the STUDENTS table");
    boolean|error updationStatus = updateStudent(1, "Dehami Koswatte", 30, "Homagama");

    io:println("\nTesting whether records are updated in the STUDENTS table\n");
    
    Student|error student = getStudent(1);
    if (student is Student) {
        test:assertTrue(student?.age == 30, msg = "Student with id 1 has not been updated!");
    }
}

# Test function

@test:Config {
    dependsOn: ["testUpdation"],
    after: "afterFunc"
}
function testDeletion() {

    io:println("Running function testInsertion");
    io:println("====================================================================");
    io:println("Deleting data in the STUDENTS table");
    boolean|error deletionStatus = deleteStudent(1);

    io:println("\nTesting whether records are updated in the STUDENTS table\n");

    Student|error student = getStudent(1);
    if (student is Student) {
        test:assertTrue(student?.id != 1, msg = "Student with id 1 has not been deleted!");
    }
}

# After test function

function afterFunc() {
    
    io:println("Droping the STUDENTS table after function\n");
    boolean|error droppedTableStatus = dropTable();
}

# After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}
