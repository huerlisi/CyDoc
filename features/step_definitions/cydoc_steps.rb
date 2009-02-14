Given /^a user "(.*)" with password "(.*)"$/ do |user, password|
  User.destroy_all(:login => user)
  @new_user = User.create!(:login => user, :email => "#{user}@example.com", :password => password, :password_confirmation => password )
  @new_user.register!
  @new_user.activate!
end

Given /^a doctor is logged in as "(.*)"$/ do |login|
  Given "a user \"#{login}\" with password \"monkey\""
  
  # Doctor
  Doctor.destroy_all(:login => login)
  doctor = Doctor.create!(:login => login)

  # Office
  o = Office.create!(:login => login)

  doctor.offices << o
  doctor.save!

  # Login
  visit "/login" 
  fill_in("login", :with => login) 
  fill_in("password", :with => 'monkey') 
  click_button("Anmelden")
  response.body.should =~ /Angemeldet als/m
end
