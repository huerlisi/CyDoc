# -*- encoding : utf-8 -*-
Given "an anonymous user" do
  get '/sessions/destroy'
  response.should redirect_to('/session/new')
  follow_redirect!
end

Then /^I should see the following sections:$/ do |welcomes|
  welcomes.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("h3") { |td|
        td.inner_text.should == cell
      }
    end
  end
end

# restful_authentication
# ======================
# Shameless copy
# please note: this enforces the use of a <label> field
Then "$actor should see a <$container> containing a $attributes" do |_, container, attributes|
  attributes = attributes.to_hash_from_story
  response.should have_tag(container) do
    attributes.each do |tag, label|
      case tag
      when "textfield" then with_tag "input[type='text']";     with_tag("label", label)
      when "password"  then with_tag "input[type='password']"; with_tag("label", label)
      when "submit"    then with_tag "input[type='submit'][value='#{label}']"
      else with_tag tag, label
      end
    end
  end
end
