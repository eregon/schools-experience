Feature: Subjects
  So candidates know what secondary subjects we offer for school experience
  As a school administrator
  I want to specify what subjects we offer for school experience

  Background: I have completed the wizard thus far
    Given I am logged in as a DfE user
    And the secondary school phase is availble
    And the college phase is availble
    And there are some subjects available
    And I have completed the following steps:
        | Step name                        | Extra                     |
        | DBS Requirements                 |                           |
        | Candidate Requirements choice    |                           |
        | Candidate Requirements selection |                           |
        | Fees                             | choosing only Other costs |
        | Other costs                      |                           |
        | Phases                           |                           |

  Scenario: Page title
    Given I am on the 'Subjects' page
    Then the page title should be 'Select school experience subjects'

  Scenario: Breadcrumbs
    Given I am already on the 'Subjects' page
    Then I should see the following breadcrumbs:
        | Text                              | Link               |
        | Some school                       | /schools/dashboard |
        | Select school experience subjects | None               |

  Scenario: Completing the step choosing no subjects
    Given I am on the 'Subjects' page
    When I submit the form
    Then I should see a validation error message

  Scenario: Completing the step choosing some subjects
    Given I am on the 'Subjects' page
    And I check 'Maths'
    When I submit the form
    Then I should be on the 'Description' page
