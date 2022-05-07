Feature: Articles
  Background:
    Given url URL
    * def articleRequestBody = read('classpath:helpers/articleBody.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title

    Scenario: Create a new article
      Given path 'articles'
      * def payload = articleRequestBody
      And request payload
      When method post
      Then status 200
      And match response.article.body == articleRequestBody.article.body
      And match response.article.title == articleRequestBody.article.title
      And match response.article.description == articleRequestBody.article.description

    Scenario: Delete an article
      Given path 'articles'
      * def random = function(){ var temp = ''; karate.repeat(10, function(){ temp += Math.floor(Math.random() * 9) + 1 }); return temp; }
      * def randomString = random()
      * print "Random input: " + randomString
      * def payload = articleRequestBody
      * payload.article.title = "TITLE" + randomString
      And request payload
      When method post
      Then status 200
      * def articleID = response.article.slug
      * print articleID

      Given path 'articles'
      And params { limit: 3, offset: 0, author: "karate-developer" }
      When method get
      Then status 200
      * print response.articles[0].title
      And match response.articles[0].title == "TITLE" + randomString

      Given path 'articles',articleID
      When method delete
      Then status 204