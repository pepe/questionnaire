@https://www.pivotaltracker.com/story/show/1798937 @statistics
Feature: Create page with simple statistics
  In order to have access to simple statistics
  As a supervisor
  I want to have page where I can see count summary, counts by time range

  Scenario:
    Given I know 2 questionnaires were filled in
    When I visit '/stats'
    Then I should see 'Statistika dotazníku'
    And I should see 'Jak často navštěvujete les v průměru ročně'
    And I should see 'vůbec:' followed by number
    And I should see '1 až 2 x ročně:' followed by number  
