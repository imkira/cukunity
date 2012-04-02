Feature: Run application
  In order to test Unity apps
  As a programmer 
  I must be able run/stop them first

  Scenario: Clean launch
    Given I reinstall the app "fixtures/sokoban"
    And I launch it
    Then it should be running
    And it should be running on screen

  Scenario: Launch non installed app
    Given I uninstall the app "fixtures/sokoban"
    And I launch it
    Then it should be running

  Scenario: Relaunch non running app
    Given I reinstall the app "fixtures/sokoban"
    And I relaunch it
    Then it should be running
    And it should be running on screen

  Scenario: Relaunch
    Given I reinstall the app "fixtures/sokoban"
    And I launch it
    And I relaunch it
    Then it should be running
    And it should be running on screen

  Scenario: Relaunch non installed app
    Given I uninstall the app "fixtures/sokoban"
    And I relaunch it
    Then it should be running
