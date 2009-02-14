Feature: Manage welcomes
  In order to give the client some hints where to go,
  we provide an overview page.
  
  Scenario: A logged out user requests the homepage
    Given a doctor "test" belonging to office "test office"
    And an anonymous user
    When  I go to the homepage
    Then  I should see "Anmelden"
    And   I should see a <form> containing a textfield: Login, password: Passwort, and submit: 'Anmelden'
    Then  I fill in "login" with "test"
    Then  I fill in "password" with "monkey"
    Then  I press "Anmelden"
    And   I should see "Rechnungen anzeigen"
    
