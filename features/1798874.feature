@http://www.pivotaltracker.com/story/show/1798874 @static
Feature: Create home page with basic information
  In order to have basic information about project
  As a random visitor
  I want home page with basic informations

  Scenario: Home page
    Given I visit '/'
    Then I should see 'Základní informace o dotazníku'

  Scenario: Starting questionnaire
    Given I visit '/'
    Then I should see 'Začít s dotazníkem'
