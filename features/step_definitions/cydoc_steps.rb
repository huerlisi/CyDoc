# -*- encoding : utf-8 -*-
Given /^a user "(.*)" with password "(.*)"$/ do |user, password|
  User.destroy_all(:login => user)
  @new_user = User.create!(:login => user, :email => "#{user}@example.com", :password => password, :password_confirmation => password )
  @new_user.register!
  @new_user.activate!
end

Given /^a doctor "(.*)" belonging to office "(.*)"/ do |doctor, office|
  Given "a user \"#{doctor}\" with password \"monkey\""

  # Doctor
  Doctor.destroy_all(:login => doctor)
  doctor = Doctor.create!(:login => doctor)

  # Office
  Office.destroy_all(:login => office)
  office = Office.create!(:login => office)

  doctor.offices << office
  doctor.save!
end

Given /^a doctor is logged in as "(.*)"$/ do |login|
  Given "a doctor \"#{login}\" belonging to office \"#{login}\""

  # Login
  visit "/login" 
  fill_in("login", :with => login) 
  fill_in("password", :with => 'monkey') 
  click_button("Anmelden")
  response.body.should =~ /Angemeldet als/m
end
