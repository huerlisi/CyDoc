Given "an anonymous user" do
  get '/sessions/destroy'
  response.should redirect_to('/session/new')
  follow_redirect!
end

When /^she goes toI delete the (\d+)(?:st|nd|rd|th) welcome$/ do |pos|
  visit welcomes_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following welcomes:$/ do |welcomes|
  welcomes.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
