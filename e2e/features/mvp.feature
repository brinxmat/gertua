# encoding: utf-8
# language: en

@mvp
Scenario: A user authenticates themselves
  Given that a user account for "nn@ntnu.no" exists
  When "nn@ntnu.no" requests the authentication API with valid credentials
  Then they receive a valid session token

@mvp
Scenario: A user views a work
  Given that a work exists
  When a user requests the HTTP-URI for a work
  Then the user sees details for
    | Work type[s]          | # should this be plural?
    | Work status           |
    | Preferred title       |
    | Alternative title[s]  |
    | Creator               | # In fact, this should be structured and one marked as a type "Main entry"
    | Identifier[s]         | # These must be defined, I expect
    | Part of               |
    | Has part              |
    | Precedes              |
    | Succeeds              |
    | Based on              |
    | Adapted from          |
    | Supplement to         |
    | Same As / See also    | # External relations


@developmentPeriod
Scenario: A user makes global changes
  Given that a user is authenticated
  And there are many works in the database
  When they submit a global change
  Then every affected work is changed

@developmentPeriod
Scenario: A user loads different versions of the authority file for works
  Given that a user is authenticated
  When they upload a new work authority file dataset
  Then it is given a version number and made available via the APIs

@developmentPeriod
Scenario: A user changes the data model
  Given that a user is authenticated
  When they change the ontology
  And they apply these changes via a global update
  Then they see that the data is changed

@mvp
Scenario: A user uses SPARQL to test data
  Given that there are many works in the database
  When a user submits a SPARQL query to /sparql
  Then they see the results

@mvp
Scenario: A user exports a work as a MARC record
  Given that a user requests the HTTP URI for a work
  And they specify a header "Content-type: application/marcxml+xml" # Also application/marc?
  Then they receive MARCXML data

@mvp
Scenario: A user creates a work
  Given that "nn@ntnu.no" is authenticated
  When they send valid data to the /set endpoint
  Then a new work is created
  And they see that the work has an identifier

@mvp
Scenario: A user edits a work
  Given that "nn@ntnu.no" is authenticated
  And the work "Sandy's book" exists
  When they send valid data to the /set endpoint
  Then "Sandy's book" is updated

@Ignore
Scenario: A user deletes a work
# How can we delete a work in a distributed context? Deletion is always merge because the orphaned usages need to be
# redirected to some other thing, c.f. "A user merges two works" below

# In this scenario, it is important to note that the interpretation of the reference of the "deleted work" is
# materialised as a redirect 301 (Moved permanently) or 302 (Found) and a location header for the referenced resource
# in the REST API.

@mvp
Scenario: A user merges two works
  Given that "nn@ntnu.no" is authenticated
  And the work "Sandy's book" exists
  And the work "Sandys book" exists
  When they send a valid merge request to the /merge endpoint
  Then "Sandy's book" is updated with the requested changes
  And "Sandys book" is replaced with a reference to "Sandy's book"

@mvp
Scenario: A user searches for a work by keyword
  Given that several works exist
  When the user sends a valid search by keyword request to the /search API
  Then then they receive a hit list of works

@mvp
Scenario: A user searches for a work by title
  Given that several works exist
  When the user sends /search a valid search request for a
    | Title   |
    | Creator |
  Then they receive a hit list containing exact matches

@mvp
Scenario: A user views the change log
  Given a user is authenticated
  When they request the /blame endpoint
  Then they see the change log for metadata including
    | Timestamp                     |
    | URI for the changed item      |
    | Patch document for the change |
    | Person making the change      | # Privacy issues?


@mvp
Scenario: A user creates a generic statistical report
  Given a user is authenticated
  When they request statistics from /statistics
  Then they receive a statistical report of
    | Number of works in total                  |
    | Number of works by type                   |
    | Number of relations between works         |
    | Number of relations between works by type |
    | Table of all works with ID, Title, Creator, Type, number of manifestations in (which of?) the external resources |

@mvp                                                # We don't think this is possible
Scenario: A user creates a temporally limited report
  Given a user is authenticated
  When they request statistics from /statistics with from={dateFrom} to={dateto}
  Then they see statistics for the period of time between dateFrom and dateTo including
    | Number of new works     |
    | Number of updated works |
    | "Deleted" works         |  # See above
    | New relations           |  # What does this entail? Newly minted ontology properties, or newly instantiated properties?

@versionTwo
Scenario: An third-party system user retrieves a work authority           # This isn't good UX, better to look up the creator, with linked authorities and then link from there
  Given that the user is cataloguing a manifestation of an existing work
  When they look up the work
  And link it to the manifestation
  Then the 750 field in the MARC record is updated    # Right field?

@versionTwo
Scenario: A third-party user creates a new work     # Again, not good UX
  Given that the user is cataloguing a manifestation of a work that does not exist
  When they do not find the work
  Then they are prompted to create a new work
  And they look up an authority for the creator
