Given /^a doctor is logged in as "(.*)"$/ do |login|
  User.destroy_all(:login => login)
  @current_user = User.create!(
    :login => login,
    :password => 'monkey',
    :password_confirmation => 'monkey',
    :email => "#{login}@example.com" 
  )

  # :create syntax for restful_authentication w/ aasm. Tweak as needed.
  @current_user.state = 'active'
  @current_user.save
  
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
