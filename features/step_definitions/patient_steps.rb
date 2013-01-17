# -*- encoding : utf-8 -*-
Given /I am on the new patient page/ do
  visit "/patients/new"
end

When /I am on the info page for patient "(.*)"/ do |name|
  visit patient_url(Patient.find_by_name(name))
end

Given /^the following patients:$/ do |patients|
  @patients = patients.hashes
  @patients.map!{|patient| patient["doctor"] =  Doctor.find_by_login(patient["doctor"]); patient}
  Patient.create!(@patients)
end

When /^I delete the (\d+)(?:st|nd|rd|th) patient$/ do |pos|
  visit patients_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following patients:$/ do |patients|
  patients.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
