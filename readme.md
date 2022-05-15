# Overview

Karate demo for API testing

## Run in a container

```shell
docker run -d --name karate -v $PWD:/app -w /app -v maven-repo:/root/.m2 maven:3.8-openjdk-17 mvn clean test
```

## docker-compose

```shell
docker-compose up -d
```

### Apache report

```
http://localhost:8000
```

### Nginx report

```
http://localhost:8080
```

### Regression test

```shell
docker-compose start karate-test
```

## demo user

```
username: karate-developer
email: karate@email.com
password: karate123
```

[demo test website](https://demo.realworld.io/)

## Run with tag

This will run features or scenarios tagged `@debug` using `ConduitRunner` class

```shell
mvn clean test "-Dkarate.options=--tags @debug" -Dtest=ConduitRunner
```

## Tags declared in test method

This will run a test method `testTags` in `ConduitRunner` class

```shell
mvn clean test -Dtest=ConduitRunner#testTags
```

## Skip tags

```shell
mvn clean test "-Dkarate.options=--tags ~@skip" -Dtest=ConduitRunner
```

Where:

- `ConduitRunner` runner class name
- `testTags` method name inside the given class

## A specific runner

```shell
mvn clean test -Dtest=ConduitRunner
```

## Test environment

Environment could be configured from `karate-config.js` file

```shell
mvn clean test "-Dkarate.options=--tags @debug" -Dtest=ConduitRunner -DKarate.env="dev"
```

## Apache config

Inside `httpd` directory there is `.htaccess` file to configure the index page for the cucumber report direcotry.

For this to work the general apache config file `httpd/httpd.conf` should be mounted into the container.

## nginx config

```shell
docker run -d -p 8004:80 -v $PWD/nginx/default.conf:/etc/nginx/conf.d/default.conf -v cucumber-report:/usr/share/nginx/html nginx:1.14
```