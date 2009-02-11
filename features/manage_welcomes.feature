Feature: Manage welcomes
  In order to give the client some hints where to go,
  we provide an overview page.
  
  Scenario: Anonymous user gets redirected to login and lands on welcome page
    Given an anonymous user
    When  I go to the homepage
    Then  I should see "Anmelden"
     And  she should see a <form> containing a textfield: Login, password: Passwort, and submit: 'Anmelden &#187;'
