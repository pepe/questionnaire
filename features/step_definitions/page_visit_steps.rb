Given /^I visit '(.+)'$/ do |url|
  visit(url)
end

Given /^I am viewing '(.+)'$/ do |url|
  Given "I visit '#{url}'"
end
 
Then /^I should see '([^']+)'$/ do |text|
  response_body.should contain(text)
end

Then /^I should not see '(.+)'$/ do |text|
  response_body.should_not contain(text)
end

Then /^I should see big '(.+)'$/ do |text|
  text = '<h1>[\s]*%s[\s]*<\/h1>' % text
  response_body.should =~ Regexp.new(text)
end

Then /^I fill in '(.*)' for '(.*)'$/ do |value, field|
  fill_in(field, :with => value)
end

When /^I press '(.*)'$/ do |name|
  click_button(name)
end

Then /^I choose '(.*)'$/ do |value|
  choose(value) 
end

Given /^I will get mail$/ do
  Pony.should_receive(:mail)
end

Then /^I follow '(.+)'$/ do |link|
  click_link link
end

When /^I select '(.+)' from '(.+)'$/ do |value, field|
  select(value, :from => field) 
end

