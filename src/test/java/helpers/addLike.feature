Feature: Add article to favorites
  Background:
    * url URL

  Scenario: Like article
    Given path 'articles', slug, 'favorite'
    When method post
    Then status 200
    * def likes = response.article.favoritesCount