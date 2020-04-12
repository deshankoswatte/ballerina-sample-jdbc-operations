#!/bin/bash
ballerina build -a
cd target/bin
ballerina run manage_students.jar
ballerina run students_service.jar