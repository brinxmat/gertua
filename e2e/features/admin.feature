# encoding: utf-8
# lang: en

Feature: Admin user features

  Scenario: An API-admin user is authenticated and authorised
    Given that there is an API-admin user
    When the API-admin user provides valid credentials
    Then the API-admin user is authorised to use the admin API services

  Scenario: An API-admin user creates a new entity registry
    Given that that the API-admin user is authenticated
    When the API-admin user provides a properly formatted create entity registry request providing information about:
      | Register name              |
      | Register admin users       |
      | Register validation schema |
    Then an entity registry that accepts only valid data is created

  Scenario: An API-admin user adds a single entity to a registry
    Given that the API-admin user is authenticated
    And that there is an existing entity registry with a schema
    When the API-admin user requests the creation of a new entity with correctly formatted data
    Then the entity is created

  @NotAdmin
  Scenario: An API user views an entity without specifying a format
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the API-admin user requests the entity
    Then API-admin user can view the data in the native database format
    
  Scenario: An API-admin user views an entity specifying a specific format
    Given that the API-admin user is authenticated
    And that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the API-admin user requests the entity with format:
      | application/ld+json     |
      | application/n-triples   |
      | application/rdf+xml     |
      | application/turtle      |
      | text/html               |
      | application/json        |
      | application/rdf         |
      | application/marcxml+xml |
      | application/marc        |
      | application/mads+xml    |
      | application/marcxml     |
    Then API-admin user can view the data in the format
  
  @NotAdmin
  @NotMVP
  Scenario: An API-user views an entity specifying a specific format and specific profile
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the API-admin user requests the entity with format:
      | application/ld+json     |
      | application/n-triples   |
      | application/rdf+xml     |
      | application/turtle      |
      | application/json        |
      | application/rdf         |
    And specifies a request header Accept-schema with a value:
      | native-uri   |
      | skos-uri     |
      | bibframe-uri |
    Then API-admin user can view the data in the format and schema requested

  Scenario: An API-Admin user populates a registry
    Given that the API-admin user is authenticated
    And that there is an existing entity registry with a schema
    And that the API-admin user has a set of properly schema-formatted data
    When the API-admin user bulk uploads the data to the entity registry
    Then the data is available in the entity registry

  Scenario: An API-admin user deletes an existing, empty entity registry
    Given that the API-admin user is authenticated
    And that there is an existing, empty entity registry
    When the API-admin user request deletion of an entity registry
    Then the empty entity registry is deleted

  Scenario: An API-admin user updates an existing, empty entity registry
    Given that the API-admin user is authenticated
    And that there is an existing, empty entity registry
    When the API-admin user updates the metadata and validation schemas of the entity registry
    Then the entity registry is updated

  Scenario: An API-admin user attempts to delete an existing, populated entity registry
    Given that the API-admin user is authenticated
    And that there is an existing, populated entity registry
    When the API-admin user attempts to delete the entity registry
    Then the API-admin user receives information that they cannot delete the entity registry until the populated data is deleted

  Scenario: An API-admin user attempts to update an existing, populated entity registry
    Given that the API-admin user is authenticated
    And that there is an existing, populated entity registry
    When the API-admin user attempts to update the entity registry
    Then the API-admin user receives information that they cannot delete the entity registry until the populated data is deleted

  Scenario: An API-admin user deletes populated data from an entity registry
    Given that the API-admin user is authenticated
    And that there is an existing, populated entity registry
    When the API-admin user deletes the data in the entity registry
    Then the API-admin user receives information that the data is deleted


