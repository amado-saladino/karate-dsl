Feature: Sign up new user

  Background:
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def isValidTime = read('classpath:helpers/timeValidator.js')
    * def rndEmail = dataGenerator.getRandomEmail()
    * def rndName = dataGenerator.getRandomUsername()
    Given url URL

  Scenario: Create a user
    * def randomEmailNonStaticFn =
    """
    function() {
      var Generator = Java.type('helpers.DataGenerator')
      var generator = new Generator()
      return generator.getEmail()
    }
    """
    * def emailSample = randomEmailNonStaticFn()
    * print "Sample EMAIL: " + emailSample

    Given path 'users'
    And request
    """
    {
	"user": {
		"username": #(rndName),
		"email": #(rndEmail),
		"password": "anypassword"
      }
    }
    """
    When method post
    Then status 200
    And match response ==
    """
    {
      "user": {
          "email": #(rndEmail),
          "username": #(rndName),
          "bio": null,
          "image": "#regex ^https:\/\/api\\.realworld\\.io\/images\/.*jpeg$",
          "token": "#string"
      }
}
    """

  Scenario Outline: Validate sign-up error messages
    Given path 'users'
    And request
    """
    {
	"user": {
		"username": "<username>",
		"email": "<email>",
		"password": "<password>"
      }
    }
    """
    When method post
    Then status 422
    And match response == <error>

    Examples:
      | email            | username         | password  | error                                              |
      | #(rndEmail)      | karate-developer | karate123 | {"errors":{"username":["has already been taken"]}} |
      | karate@email.com | #(rndName)       | karate123 | {"errors":{"email":["has already been taken"]}}    |