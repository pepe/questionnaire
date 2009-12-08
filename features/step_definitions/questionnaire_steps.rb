Given /^I started new questionnaire$/ do
  Given "I visit '/'"
  Then "I follow 'Pro vyplnění dotazníku prosím klikněte zde'"
end
Given /^I filled first part of questionnaire$/ do
  Given "I started new questionnaire"
  And "I choose 'vůbec'"
  And "I fill in '10' for 'hodin'"
  And "I select '1' from 'purpose_relaxation'"
  And "I select '1' from 'purpose_hobbitry'"
  And "I select '1' from 'purpose_gathering'"
  And "I select '1' from 'purpose_fuel'"
  And "I fill in 'nahoře' for 'favorite_place'"
  And "I press 'Odeslat I. část'"
end
Given /^I fill in both parts of questionnaire$/ do
  Given "I filled first part of questionnaire"
  And "I fill in '10' for 'once_payment'"
  And "I fill in '10' for 'once_receive'"
  And "I select '1' from 'important_wood'"
  And "I select '1' from 'important_gathering'"
  And "I select '1' from 'important_water'"
  And "I select '1' from 'important_ground'"
  And "I select '1' from 'important_climate'"
  And "I select '1' from 'important_health'"
  And "I select '1' from 'important_nature'"
  And "I choose 'jsem student/studentka'"
  And "I press 'Odeslat II. část'"
end
Then /^I should see unique code$/ do
  response_body.should =~ /\b[0-9a-f]{32}\b/
end
Then /^I should see '(.+)' and time$/ do |text|
  response_body.should =~ /#{text} \d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}/
end
Then /^I should see '(.+)' followed by number$/ do |text|
  response_body.should =~ /#{text} \d+/
end
When /^I follow unique code$/ do
  click_link /\b[0-9a-f]{32}\b/
end
Given /^I know 2 questionnaires were filled in$/ do
  2.times {Given "I fill in both parts of questionnaire"}
end

