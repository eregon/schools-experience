Feature: DBS requirements
  So I can ensure we accept suitable vetted candidates
  As a school administrator
  I want to specify our DBS requirements

  Background:
    Given I am logged in as a DfE user

  Scenario: Page title
    Given I am on the 'DBS requirements' page
    Then the page title should be 'DBS requirements'

  Scenario: Completing step chosing yes
    Given I am on the 'DBS requirements' page
    And I choose 'Yes - Outline your DBS requirements' from the 'Do you require candidates to have or get a DBS check?' radio buttons
    And I enter 'Always require DBS check' into the 'Provide details in 50 words or less.' text area
    When I submit the form
    Then I should be on the 'candidate requirements choice' page

  Scenario: Completing step chosing no
    Given I am on the 'DBS requirements' page
    And I choose 'No - Candidates will be accompanied at all times' from the 'Do you require candidates to have or get a DBS check?' radio buttons
    When I submit the form
    Then I should be on the 'candidate requirements choice' page
