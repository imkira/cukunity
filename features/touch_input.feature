Feature: Touch Input
  In order to test a game as a human player would do
  As a programmer
  I want to be able to simulate touch input events

  Background:
    Given I install the app "fixtures/sokoban"
    And I launch it
    And I load the "demo_title" level

  Scenario: Application finished launching
    Then it should be running
    And it should be playing "demo_title" level
    And I should have a GameObject named "MainMenu"
    And I should not have a GameObject named "OptionsMenu"

  Scenario: Clear game
    When I set the default tap delay to 0.5 seconds
    And I tap "Play"
    And I tap "Up"
    And I tap "Up"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Up"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Up"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Right"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Up"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    And I tap "Left"
    And I tap "Up"
    Then I should see "GameClear"
    And I should read "40"

  Scenario: Quit application by tap the "Quit" menu button
    When I tap "Quit" and wait 3 seconds
    Then it should not be running

  Scenario: Enter options menu
    When I tap "Options" and wait 1 second
    Then I should have a GameObject named "OptionsMenu"
    And I should not have a GameObject named "MainMenu"
