Feature: Get Scene Command
  In order to inspect the state of a Unity game
  As a programmer
  I want to be able to get the current scene contents

  Background:
    Given I install the app "fixtures/sokoban"
    And I launch it
    And I load the "demo_title" level

  Scenario: Get game object by name (short form)
    Then I should have a "Main Camera"

  Scenario: Get game object by name (full form)
    Then I should have a GameObject named "Main Camera"

  Scenario: Get component on a game object (direct form)
    Then I should have a Camera on "Main Camera"

  Scenario: Get component on a game object (indirect form)
    Then I should have a GameObject named "Main Camera"
    And it should have a Camera component

  Scenario: Check boolean properties on a game object
    Then I should have a GameObject named "Main Camera"
    And it should be "active"

  Scenario: Check boolean properties on a component
    Then I should have a Camera named "Main Camera"
    And it should be "enabled"

  Scenario: Check any property on a game object as string
    Then I should have a GameObject named "Main Camera"
    And it should have "active" property as "true"

  Scenario: Check any property on a component as string
    Then I should have a Camera named "Main Camera"
    And it should have "enabled" property as "true"
    And it should have "renderingPath" property as "UsePlayerSettings"
