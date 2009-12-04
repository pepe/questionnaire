Given /^I fill in both parts of questionnaire$/ do
  Given "I visit '/'"
  Then "I follow 'Pro vyplnění dotazníku prosím klikněte zde'"
  And "I choose 'vůbec'"
  And "I fill in '10' for 'hodin'"
  And "I select '1' from 'purpose_relaxation'"
  And "I select '1' from 'purpose_hobbitry'"
  And "I select '1' from 'purpose_gathering'"
  And "I select '1' from 'purpose_fuel'"
  And "I fill in 'nahoře' for 'favorite_place'"
  And "I press 'Odeslat I. část'"
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
  response_body.should =~ /\b[0-9a-f]{40}\b/
end

