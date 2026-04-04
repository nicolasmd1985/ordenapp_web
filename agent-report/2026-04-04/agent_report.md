# AGENT_REPORT.md

## Subsidiary Model Tests

### Added spec/factories/subsidiaries.rb
- Created a FactoryBot for Subsidiary model with all required fields including corporation and status.

### Added spec/models/subsidiary_spec.rb
- Added tests for associations and callbacks.
- Included validation checks for required fields and association validations.

### Added spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb
- Added test cases for admin user and non-admin user.
- Included validation errors for missing required fields.

All tests ensure that Subsidiary model and its mutations work as expected.