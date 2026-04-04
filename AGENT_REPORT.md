

# AGENT_REPORT.md

## Changes Made

- Created `spec/factories/subsidiaries.rb` and `spec/factories/corporations.rb` for FactoryBot factories.
- Created `spec/factories/statuses.rb` for FactoryBot factories.
- Created `spec/rails_helper.rb` to include FactoryBot methods.
- Created `spec/models/subsidiary_spec.rb` with all model associations, callbacks, and initializers.
- Created `spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb` to test the API endpoints and ensure that only admin users can create subsidiaries.
