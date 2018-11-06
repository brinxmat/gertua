# encoding: utf-8
# lang: en

# Example scenarios for end users

Feature: An end user uses the service

  @MVP2
  Scenario: An end user uses an authority in their library system
    Given that the end user is logged in in their library system
    And that they are cataloguing a thing in the metadata client
    When they click on field:
      | 648 |
      | 650 |
      | 655 |
      | 651 |
    And they select a subject heading source from:
      | HUMORD         |
      | UJUR           |
      | Realfagstermer |
    And they enter a search term in the search box that appears
    And they select the correct term from the dropdown list that appears as they type
    Then they see that subfield $a is populated with the subject heading label
    And they see that subfield $b, $x, $y and $z are populated (where these are relevant)
    And they see that subfield $2 is populated with the source
    And they see that subfield $0 is populated with the subject heading URI
  
  @WIP
  Scenario: An end user adds a new subject heading
    Given that the end user is logged in in their library system
    And that they are cataloguing a thing
    When they click on field 690
    And they enter a search term in the search box that appears
    And they do not see the term they are looking for in the drop-down list that appears as they type
    And they click on "Add new term"
    And they see a screen pre-populated with the term they searched for
    And they add additional metadata for
      | Broader term  |
      | Narrower term |
      | Definition    |
    And they click save
    Then they see that the term is saved
    And they see that subfield $a is populated with the subject heading label
    And they see that subfield $0 is populated with the subject heading URI
    
