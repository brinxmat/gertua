# encoding: utf-8
# lang: en

# API admin, superuser responsibility for user administration, creating/removing entity registries
# Registry admin, administer data in registry
# Anonymous user, download data from registry

Feature: Admin user features

  Scenario: An API admin user provides a valid API key
    Given that an API admin user has a valid API key for API administration
    When they submit the API key
    Then they can access the administration APIs

  Scenario: An API admin user creates a new entity registry
    Given that the API admin user has a valid API key for API administration
    When the API admin user submits the API key and a properly formatted create-entity-registry-request providing information about:
      | Registry name              |
      | Registry admin users       |
      | Registry validation schema |
    Then an entity registry that accepts only valid data is created

  Scenario: An registry admin user adds a single entity to a registry
    Given that the registry admin user has a valid API key for registry administration
    And that there is an existing entity registry with a schema
    When the registry admin user submits the API key with a request to create a new entity with properly formatted data
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
    Given that the registry admin user has a valid API key for registry administration
    And that there is an existing entity registry with a schema
    And that the registry admin user has a set of properly schema-formatted data
    When the registry admin user submits an API key and a request to bulk upload the data to the entity registry
    Then the data is available in the entity registry

  Scenario: An API admin user deletes an existing, empty entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, empty entity registry with a schema
    When the API admin user uses the API key and requests deletion of an entity registry
    Then the empty entity registry is deleted

  Scenario: An API admin user updates an existing, empty entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, empty entity registry with a schema
    When the API admin user uses the API key and submits a request to update the validation schema of the entity registry
    Then the entity registry is updated

  Scenario: An API admin user deletes an existing, populated entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user uses the API key and submits a request to delete the entity registry
    Then the API admin user receives information that the entity registry is deleted

  Scenario: An API admin user attempts to update the validation schema of an existing, populated entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user uses the API key and submits a request to update the validation schema of the entity registry
    Then the API admin user receives information that they cannot update the entity registry validation schema until the populated data is deleted

  @WontFix
  Scenario: An API admin user deletes populated data from an entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user uses the API key and submits a request to delete the data in the entity registry
    Then the API admin user receives information that the data is deleted

  Scenario: An API admin user associates an API key with the registry admin role for a registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user requests a new API key to replace the current valid API key
    Then the API key is updated
    And the user receives the updated API key

  @NotMVP
  Scenario: A registry admin adds registry admin API keys to an existing, populated entity registry
    Given that the registry admin user has a valid API key for registry administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user adds registry admin API keys to the entity registry
    Then the users with the API keys can access the entity registry

  Scenario: An API admin user removes registry admin API keys from an existing, populated entity registry
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema and registered registry API keys
    When the API admin user removes registry admin API keys from the entity registry
    Then the API keys no longer provide access to the entity registry

  Scenario: An API admin user updates the entity registry metadata
    Given that the API admin user has a valid API key for API administration
    And that there is an existing, populated entity registry with a schema
    When the API admin user changes the metadata for the entity registry
    Then the metadata for the entity registry is updated

  Scenario: An anonymous user views the metadata for a registry as HTML
    Given that there is an existing populated entity registry with a schema
    When an anonymous user dereferences the base URI for the registry specifying mediatype text/html
    Then they see metadata related to the entity registry regarding:
      | Registry name                    |
      | Registry type                    |
      | Publisher                        |
      | License for the data             |
      | Owner organisation               |
      | Participating organisations      |
      | Languages used in dataset        |
      | Creation date                    |
      | Modification date                |
      | Relations to other data sets     |
      | Location of APIs                 |
      | Example resources                |
      | Base URI for dataset             |
      | Location of SPARQL endpoint      |
      | Description of available formats |

  Scenario: An anonymous user views the metadata for a registry as RDF
    Given that there is an existing populated entity registry with a schema
    When an anonymous user dereferences the base URI for the registry specifying mediatypes:
      | application/ld+json     |
      | application/n-triples   |
      | application/rdf+xml     |
      | application/turtle      |
      | application/json        |
      | application/rdf         |
    Then they see metadata related to the entity registry regarding:
      | Metatata                |
      | Available data profiles |
