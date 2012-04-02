Feature: Keyboard Input
  In order to test a game as a human player would do
  As a programmer
  I want to be able to simulate keyboard input events

  Background:
    Given I install the app "fixtures/sokoban"
    And I relaunch it
    And I tap "Options"

  Scenario: Application finished launching
    Then I should read "PLAYER NAME:"
    And I should not read "Super Player"
    And I should read "Guest"

  Scenario: Set player name 
    When I tap "PlayerName"
    And I type "Super Player" using "InputMethodServiceGlue"
    Then I should read "Super Player"

  Scenario: Player name is displayed during play
    When I tap "PlayerName"
    And I append "Player" using "InputMethodServiceGlue"
    And I tap "Ok" and wait 1 second
    And I tap "Play" and wait 1 second
    Then I should read "GuestPlayer"
