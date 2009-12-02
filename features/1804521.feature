@https://www.pivotaltracker.com/story/show/1804521 @core
Feature: Add saving to database
  In order to check my questionnaire later
  As a respondent
  I want to have my code on thank you page and address for review my answers

  Scenario: Getting code and permalink
    Given I fill in both parts of questionnaire
    Then I should see 'Unikátní kód Vašeho dotazníku je:'
    And I should see unique code
