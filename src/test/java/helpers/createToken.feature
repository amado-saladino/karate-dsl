Feature: Create Token
  Scenario: create the login token
    Given url URL
    And path 'users/login'
    And request {"user": {"email": "#(EMAIL)", "password": "#(PASSWORD)"}}
    When method post
    Then status 200
    * def authToken = response.user.token