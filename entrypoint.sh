#! /bin/bash

mvn clean test
status=$?
cp -r /app/target/cucumber-html-reports/* /report

cp /app/httpd/.htaccess /report
exit $status