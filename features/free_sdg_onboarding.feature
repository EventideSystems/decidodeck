Feature: Free SDG Onboarding

  As a visitor interested in the Free SDG programme
  I want to sign up and onboard via a dedicated flow
  So I can quickly access Free SDG resources

  Scenario: Starting onboarding from the Free SDG landing page
    Given I am not logged in
    And I am visiting the Free SDG landing page
    When I click the "Get Started" link
    And I wait for registration form to load
    And I enter my registration details and submit the form
    Then I should receive an email asking me to confirm my registration

  Scenario: Signing in for the first time as a Free SDG user
    Given I have registered a Free SDG user account
    And I have confirmed my Free SDG user account
    When I sign in for the first time
    Then I will be presented with a welcome message

  Scenario: Accessing default stakeholder types
    Given I have registered a Free SDG user account
    And I have confirmed my Free SDG user account
    When I sign in for the first time
    And I visit the stakeholder types page
    Then I will see a list of default stakeholder types

  @javascript
  Scenario: Accessing data models
    Given I have registered a Free SDG user account
    And I have confirmed my Free SDG user account
    When I sign in for the first time
    And I visit the library page
    And I should see a link to "Sustainable Development Goals and Targets"
    And I should not see a link to any other data models

  # Scenario: Creating an impact card as a Free SDG user
  #   Given I am signed in as a Free SDG user
  #   When I visit the impact card creation page
  #   Then I should see a form to create a new impact card
  #   And I should not see any fields related to paid features
