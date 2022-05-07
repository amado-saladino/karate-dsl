Feature: After all feature
  Scenario:
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def article = dataGenerator.getRandomArticleValues()
    * print article