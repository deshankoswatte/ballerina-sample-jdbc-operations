# ballerina-sample-jdbc-operations

## Table of Contents

* [About the Project](#about-the-project)
* [Prerequisites](#prerequisites)
* [Try out the project](#try-out-the-project)
* [Contributing](#contributing)
* [License](#license)

## About the project

 Ballerina code sample for database related operations with JDBC which are exposed as API endpoints using a ballerina service. Underlying scenaio is a student management system where you can add edit and delete them. You can find the UI for the service at https://github.com/deshankoswatte/student-data-collector-frontend.

## Prerequisites

You should have installed:
- Ballerina or you can download and install it through https://ballerina.io/learn/installing-ballerina/.

## Try out the project

- Clone the repository to a place of your preference using the command `git clone https://github.com/deshankoswatte/ballerina-sample-jdbc-operations.git`.
- Open the cloned repository folder.
- Run the program using the command using `jdbc_operations.activate.sh` on the root folder.
- Import the postman collection `student.postman_collection.json` located at `src/students_service/resources/student.postman_collection.json` and try out the requests by changing the parameters or you can try it out with the frontend located at `https://github.com/deshankoswatte/student-data-collector-frontend`.

## Contributing

Contributions make the open source community such an amazing place to learn, inspire, and create. Any contribution you make to this project is **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

## License

Distributed under the Apache License 2.0. See `LICENSE` for more information.

