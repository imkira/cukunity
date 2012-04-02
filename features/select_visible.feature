Feature: Select Visible Objects
  In order to inspect the state of a Unity game
  As a programmer
  I want to be able select visible objects in the game scene

  Background:
    Given I install the app "fixtures/sokoban"
    And I relaunch it

  Scenario: Application displays main menu
    Then I should see "Play"
    And I should see "Options"
    And I should see "Quit"
    But I should not see "Ok"

  Scenario: Options menu displays labels
    When I tap "Options" and wait 1 second
    Then I should read "PLAYER NAME:"

  Scenario: Play scene displays buttons and labels
    When I tap "Play" and wait 1 second
    Then I should see "Left"
    And I should see "Up"
    And I should see "Right"
    And I should see "Quit"
    And I should see "Retry"
    And I should not see "GameClear"
    And I should read "Guest"
    And I should read "0"
