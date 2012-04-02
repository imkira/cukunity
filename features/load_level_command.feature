Feature: Load Level Command
  In order to test Unity games faster
  As a programmer 
  I want to be able to force the loading of a game level

  Background:
    Given I install the app "fixtures/sokoban.apk"
    And I launch it

  Scenario: Reload scene (using level name)
    When I load the "demo_title" level
    Then it should be playing "demo_title" level 
    And it should not be playing "demo_game" level 
    Then it should be playing level 0
    And it should not be playing level 1

  Scenario: Reload scene (using level number)
    When I load level 0
    Then it should be playing level 0
    And it should not be playing level 1
    And it should be playing "demo_title" level 
    And it should not be playing "demo_game" level 

  Scenario: Load different scene(using level name)
    When I load the "demo_game" level
    Then it should be playing "demo_game" level 
    And it should not be playing "demo_title" level 
    And it should be playing level 1
    And it should not be playing level 0

  Scenario: Load different scene(using level number)
    When I load level 1
    Then it should be playing level 1
    And it should not be playing level 0
    And it should be playing "demo_game" level 
    And it should not be playing "demo_title" level 
