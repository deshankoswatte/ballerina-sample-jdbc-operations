# 
# Blueprint for the Student record.
#
# + id       - id Parameter: Id of the student. 
# + fullName - fullName Parameter: Fullname of the student. 
# + age      - age Parameter: Age of the student.
# + address  - address Parameter: Address of the student.
public type Student record {
    int id;
    string fullName;
    int age;
    string address;
};