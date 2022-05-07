Feature: dummy feature
  Scenario:
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def username = dataGenerator.getRandomUsername()
