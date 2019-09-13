Feature: a user adds a linked term

  Given that the user is editing a term in a prepopulate database
  And they have filled in required properties
  When they click Add 
   | broader  |
   | narrower |
   | related  |
  And they enter a search term "Swati" in the input field
  And they select the matching hit "Swati språk" in the hit list
  And they click OK to confirm and close the window
  Then the text "Swati språk" is visible in the form field
  And the HTTP-URI for Swati språk is visible as the value of the data field
