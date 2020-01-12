# HTTP_Service Module Overview
_**Exposes database functions**_ as _API endpoints_ using a ballerina service.

## Endpoint Overview and Description
Contains the following API endpoints:

- `localhost:9090/student/getAllStudents`
    - _API endpoint_ to **get all the students** persisted in the `STUDENTS` table.
- `localhost:9090/student/getStudent/<studentId>`
    - _API endpoint_ to **get a student** from the `STUDENTS` table based on the specified `studentId`.
- `localhost:9090/student/insertStudent`
    - _API endpoint_ to **insert a student** into the `STUDENTS` table.
- `localhost:9090/student/updateStudent`
    - _API endpoint_ to **update a student** persisted in the `STUDENTS` table.
- `localhost:9090/student/deleteStudent/<studentId>`
    - _API endpoint_ to **delete a student** from the `STUDENTS` table based on the specified `studentId`.
