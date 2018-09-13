# encoding: utf-8
# lang: en

# API admin, superuser responsibility for user administration, creating/removing entity registries
# Registry admin, administer data in registry
# Anonymous user, download data from registry

Feature: Admin user features

  Scenario: An API admin user authenticates themselves
    Given that there is an API admin user with valid credentials
    When they provide these credentials
    Then they are authenticated and receive a valid authentication token

  Scenario: An API admin user is authorised
    Given that an API admin user has a valid authentication token
    When they submit the authentication token
    Then they are authorised to access the administration APIs

  Scenario: An API admin user creates a new entity registry
    Given that the API admin user is authenticated
    When the API admin user provides a properly formatted create-entity-registry-request providing information about:
      | Registry name              |
      | Registry admin users       |
      | Registry validation schema |
    Then an entity registry that accepts only valid data is created

  Scenario: An registry admin user adds a single entity to a registry
    Given that the registry admin user is authenticated
    And that there is an existing entity registry with a schema
    When the registry admin user requests the creation of a new entity with properly formatted data
    Then the entity is created
 
  Scenario: An anonymous user views an entity without specifying a format
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the anonymous user requests the entity
    Then anonymous user can view the entity's data in the native database format

  Scenario: An anonymous user views API information
    And that there is an existing entity registry with a schema
    When an anonymous user requests the OpenAPI documentation
    Then the OpenAPI documentation is returned

  Scenario: An anonymous user submits a request to see if a resource is modified
    Given that there is an existing entity registry with a schema
    And that there is an existing entity in the registry
    When the anonymous user requests the entity
    Then the response contains an ETag and a Last-Modified header
    
  Scenario: An anonymous user views an entity specifying an RDF serialization
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the anonymous user requests the entity specifying an Accept header with value:
      | application/ld+json     |
      | application/n-triples   |
      | application/rdf+xml     |
      | application/turtle      |
      | application/json        |
      | application/rdf         |
    Then anonymous user can view the data in the given serialization

  Scenario: An anonymous user views an entity as HTML
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the anonymous user requests the entity specifying an Accept header with value text/html
    Then anonymous user can view the data in the given format

  Scenario: An anonymous user views an entity specifying a specific MARC format
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the anonymous user requests the entity specifying an Accept header with value:
      | application/marcxml+xml |
      | application/marc        |
      | application/mads+xml    |
      | application/marcxml     |
    Then anonymous user can view the data in the given MARC format
  
  @NotMVP
  Scenario: An anonymous user views an entity specifying a specific RDF serialization and a specific profile
    Given that there is an existing entity registry with a schema
    And that there is an entity in the registry
    When the anonymous user requests the entity specifying an Accept header with value:
      | application/ld+json     |
      | application/n-triples   |
      | application/rdf+xml     |
      | application/turtle      |
      | application/json        |
      | application/rdf         |
    And specifies an Accept-schema header with a value:
      | native-uri   |
      | skos-uri     |
      | bibframe-uri |
    Then anonymous user can view the data in the serialization and profile requested

  Scenario: A registry admin user populates a registry
    Given that the registry admin user is authenticated
    And that there is an existing entity registry with a schema
    And that the registry admin user has a set of properly schema-formatted data
    When the registry admin user bulk uploads the data to the entity registry
    Then the data is available in the entity registry

  Scenario: An API admin user deletes an existing, empty entity registry
    Given that the API admin user is authenticated
    And that there is an existing, empty entity registry with a schema
    When the API admin user request deletion of an entity registry
    Then the empty entity registry is deleted

  Scenario: An API admin user updates an existing, empty entity registry
    Given that the API admin user is authenticated
    And that there is an existing, empty entity registry with a schema
    When the API admin user updates the metadata and validation schemas of the entity registry
    Then the entity registry is updated

  Scenario: An API admin user attempts to delete an existing, populated entity registry
    Given that the API admin user is authenticated
    And that there is an existing, populated entity registry with a schema
    When the API admin user attempts to delete the entity registry
    Then the API admin user receives information that they cannot delete the entity registry until the populated data is deleted

  Scenario: An API admin user attempts to update an existing, populated entity registry
    Given that the API admin user is authenticated
    And that there is an existing, populated entity registry with a schema
    When the API admin user attempts to update the entity registry
    Then the API admin user receives information that they cannot delete the entity registry until the populated data is deleted

  Scenario: An API admin user deletes populated data from an entity registry
    Given that the API admin user is authenticated
    And that there is an existing, populated entity registry with a schema
    When the API admin user deletes the data in the entity registry
    Then the API admin user receives information that the data is deleted


