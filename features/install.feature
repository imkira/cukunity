@install
Feature: Install application
  In order to test Unity apps
  As a programmer
  I must be able install them first

  Background:
    Given I uninstall the app "fixtures/sokoban"

  Scenario: Direct uninstall
    Then it should not be installed

  Scenario: Clean install
    Given I install it
    Then it should be installed

  Scenario: Reinstall
    Given I reinstall it
    Then it should be installed

  Scenario: Install then uninstall
    Given I install the app "fixtures/sokoban"
    And I uninstall it
    Then it should not be installed
