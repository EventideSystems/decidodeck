Feature: Free SDG Landing Page

  As a visitor using a Free SDG domain
  I want to be taken to a special landing page
  So I can learn about the Free SDG programme

  Scenario: Visiting the site with a 'free-sdg' domain
    Given I am not logged in
    And I visit the site using a domain containing 'free-sdg'
    Then I should see the Free SDG landing page
    And I should see information about the Free SDG programme
    And I should see a call to action to find out more
