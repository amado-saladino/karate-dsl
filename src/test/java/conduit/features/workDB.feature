Feature: DB work
  Background: DB connection
    * def handler = Java.type('helpers.DbHandler')

    Scenario: add job to DB
      * eval handler.addNewJobWithName('DevOps Engineer')

      Scenario: get min and max levels for a job
        * def level = handler.getMinAndMaxLevelsForJob("Publisher")
        * print level.minLvl
        * print level.maxLvl