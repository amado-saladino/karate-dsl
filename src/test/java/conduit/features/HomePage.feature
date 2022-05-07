Feature: Home Page tests
  Background:
    Given url 'https://api.realworld.io/api'
    * def users = read('classpath:helpers/MOCK_DATA.json')

  Scenario: Get all tags
    And path 'tags'
    When method get
    Then status 200
    And match response.tags contains 'welcome'
    And match response.tags contains ['implementations', 'introduction']
    And match response.tags !contains ['value1', 'programming']
    And match each response.tags == "#string"

    # Request URL: https://api.realworld.io/api/articles?limit=10&offset=0
  Scenario: Get 10 articles
    And path 'articles'
    And param limit = 10
    And param offset = 0
    When method get
    Then status 200
    And assert response.articlesCount > 0
    And assert response.articles.length > 0
    And match each response..image == '#regex ^https:\/\/api\.realworld\.io\/images\/.*jpeg$'

  Scenario: Get 3 articles
    * def isValidTime = read('classpath:helpers/timeValidator.js')
    And path 'articles'
    And params { limit: 3, offset: 0 }
    When method get
    Then status 200
    And match response.articles == "#array"
    And match response.articles == "#[3]"
    And match response == {"articles": "#array", "articlesCount": "#number"	}
    And match response.articles[*].slug !contains null
    And match each response.articles ==
    """
    {
          "slug": '#string',
          "title": '#string',
          "description": "#string",
          "body": "#string",
          "createdAt": "#? isValidTime(_)",
          "updatedAt": "#? isValidTime(_)",
          "tagList": "#array",
          "author": {
              "username": '#string',
              "bio": '##string',
              "image": "#regex ^https:\/\/api\\.realworld\\.io\/images\/.*jpeg$",
              "following": '#boolean'
          },
          "favoritesCount": "#number",
          "favorited": "#boolean"
      }
    """
    * def articleCount = read('classpath:helpers/countArticles.js')
    And match articleCount(response.articles) == 3

    Scenario Outline: Data-driven with json
      Given path 'tags'
      When method get
      Then status 200
      * print 'first name: ' + '<first_name>'
      * print `email: <email>`
      * print `last name: <last_name>`

      Examples:
      | users |


  Scenario: add article to favorites if not added (conditional)
    Given path 'articles'
    And params { limit: 3, offset: 0, author: "karate-developer" }
    When method get
    Then status 200
    * def firstArticle = response.articles[0]
    * def favCount = firstArticle.favoritesCount
    * if (favCount == 0) karate.call('classpath:helpers/addLike.feature', firstArticle)

    Given path 'articles', firstArticle.slug
    When method get
    Then status 200
    And match response.article.favoritesCount == 1
    And match response.article.favorited == true

    Scenario: return a value from the 'addLike' feature (conditional)
      * configure retry = { count: 10, interval: 5000 }
      Given path 'articles'
      And params { limit: 3, offset: 0, author: "karate-developer" }
      When method get
      Then status 200
      * def firstArticle = response.articles[0]
      * def favCount = firstArticle.favoritesCount
      * def result = favCount == 0 ? karate.call('classpath:helpers/addLike.feature', firstArticle).likes : favCount

      Given path 'articles', firstArticle.slug
      And retry until response.article.favorited == true
      When method get
      Then status 200
      And match response.article.favoritesCount == result
      And match response.article.favorited == true

