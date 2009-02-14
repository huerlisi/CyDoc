Feature: Manage patients
  In order to keep the patient list up to date,
  the doctor wants to be able to add, mutate and
  delete patient information.
  
  Scenario: Search for a patient
    Given a doctor is logged in as "test"
    And   I am on the new patient page
    Then  I should see a <form> containing a textfield: Suche
    When  I fill in "Suche" with "us_patient"

  Scenario: Lookup patient information
    Given a doctor is logged in as "test"
    And   the following patients:
      |name|sex|birth_date|doctor|
      |name 1|1|1999-02-03|test|
      |name 2|1|1900-01-06|test|
      |name 3|0|2001-04-07|test|
      |name 4|0|1899-12-31|test|
#    When  I am on the info page for patient "name 1"
#    Then  I should see "name 1"
