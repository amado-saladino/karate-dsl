Feature: Hooks
  Background:
    # use 'call' to call this feature everytime the test runs
    * def result = callonce read('classpath:helpers/dummy.feature')
    * def user = result.username

    # after scenario hook
    * configure afterFeature = function(){ karate.call('classpath:helpers/after-feature.feature'); }
    * configure afterScenario = function() {  karate.call('classpath:helpers/afterScenario.feature')   }

    Scenario: First Scenario
      * print "this is the first scenario"
      * print user

    Scenario: Second Scenario
      * print "this is the second scenario"
      * print user