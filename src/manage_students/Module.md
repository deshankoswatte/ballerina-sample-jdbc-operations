# Manage_Students Module Overview
_**Exposes database functions**_ to `student_service` module.

## Methods Overview and Description
Contains the following methods used for **crud operations**: 

- `createTable()`
    - Creates the initial `STUDENTS` table inside the database.
- `getAllStudents()`
    - Extracts all the students persisted in the `STUDENTS` table.
- `getStudent(int id)`
    - Extracts a student from the `STUDENTS` table based on the specified studentId.
- `insertStudent(int id, string fullName, int age, string address)`
    - Inserts a student into the `STUDENTS` table.
- `updateStudent(int id, string fullName, int age, string address)`
    - Updates a student persisted in the `STUDENTS` table.
- `deleteStudent(int id)`
    - Deletes a student from the `STUDENTS` table based on the specified studentId.
- `truncateTable()`
    - Truncates the `STUDENTS` table.
- `dropTable()`
    - Drop the `STUDENTS` table.
- `main()`
    - Execute `createTable()` which is the initial function.
    
## Notes    
- Uses the default h2 database configurations. If you want to use MySQL instead then uncomment the configurations for MySQL in `jdbc_handler.bal` copy the MySQL JDBC driver to the `BALLERINA_HOME/bre/lib` and finally comment out the configurations for h2 database.
