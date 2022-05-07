@parallel=false
Feature: Home Work

  Background: Preconditions
    * url URL

  Scenario: Favorite articles
    * def isValidTime = read('classpath:helpers/timeValidator.js')
    Given path 'articles'
    And params { limit: 10, offset: 0 }
    When method get
    Then status 200
    * def first_article = response.articles[0]
    * print first_article.slug

    Given path 'articles',first_article.slug,'favorite'
    When method post
    Then status 200
#    And match response.article.favoritesCount == first_article.favoritesCount + 1
    And match response ==
      """
       {
        "article": {
            "id": "#number",
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "createdAt": "#? isValidTime(_)",
            "updatedAt": "#? isValidTime(_)",
            "authorId": "#number",
            "tagList": #array,
            "author": {
                "username": "#string",
                "bio": ##string,
                "image": "#regex ^https:\/\/api\\.realworld\\.io\/images\/.*jpeg$",
                "following": "#boolean"
            },
            "favoritedBy": [
                {
                    "id": "#number",
                    "email": "karate@email.com",
                    "username": "karate-developer",
                    "password": "$2a$10$.qbTMSCZZMKmtYzBVeTPtOIcU4EnMnvIVNHJnYcrhn/xyJotzRKAe",
                    "image": "https://api.realworld.io/images/smiley-cyrus.jpeg",
                    "bio": null,
                    "demo": false
                }
            ],
            "favorited": true,
            "favoritesCount": "#number"
        }
    }
      """

    Given path 'articles'
    And params { favorited: 'karate-developer', limit: 5, offset: 0 }
    When method get
    Then status 200
    * print response.articles
    * def slugs = karate.jsonPath(response,"$.articles[*].slug")
    * print slugs
    And match response.articles.*slug contains first_article.slug
        # Step 1: Get atricles of the global feed
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        # Step 3: Make POST request to increse favorites count for the first article
        # Step 4: Verify response schema
        # Step 5: Verify that favorites article incremented by 1
            #Example
#            * def initialCount = 0
#            * def response = {"favoritesCount": 1}
#            * match response.favoritesCount == initialCount + 1

        # Step 6: Get all favorite articles
        # Step 7: Verify response schema
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
  Scenario: Comment articles
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def body = dataGenerator.getRandomArticleValues().body
    Given path 'articles'
    And params { limit: 10, offset: 0 }
    When method get
    Then status 200
    * def first_article = response.articles[0]

    Given path 'articles', first_article.slug, 'comments'
    When method get
    Then status 200
    * def comment_count = response.comments.length

    Given path 'articles', first_article.slug, 'comments'
    And request
    """
    {"comment":{"body":"#(body)"}}
    """
    When method post
    Then status 200
    And match response.comment contains {"body": #(body)}
    * def comment_id = response.comment.id
    * print 'comment id: ' + comment_id

    Given path 'articles', first_article.slug, 'comments'
    When method get
    Then status 200
    * def new_comment_count = response.comments.length
    And match new_comment_count == comment_count + 1

    Given path 'articles', first_article.slug, 'comments', comment_id
    When method delete
    Then status 204

    Given path 'articles', first_article.slug, 'comments'
    When method get
    Then status 200
    * def new_comment_count = response.comments.length
    And match new_comment_count == comment_count
        # Step 1: Get articles of the global feed
        # Step 2: Get the slug ID for the first article, save it to variable
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        # Step 4: Verify response schema
        # Step 5: Get the count of the comments array length and save to variable
            #Example
#    * def responseWithComments = [{"article": "first"}, {article: "second"}]
#    * def articlesCount = responseWithComments.length
        # Step 6: Make a POST request to publish a new comment
        # Step 7: Verify response schema that should contain posted comment text
        # Step 8: Get the list of all comments for this article one more time
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        # Step 10: Make a DELETE request to delete comment
        # Step 11: Get all comments again and verify number of comments decreased by 1
