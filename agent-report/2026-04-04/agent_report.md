# AGENT REPORT

## File Creation
- Created `app/models/subsidiary.rb` to define Subsidiary model associations and callback method.
- Created `app/graphql/inputs/subsidiary_input.rb` to define a create Subsidiary input object.
- Created `spec/factories/subsidiaries.rb` to define FactoryBot for Subsidiary factories.
- Created `spec/factories/corporations.rb` to define FactoryBot for Corporation factories.
- Created `spec/factories/statuses.rb` to define FactoryBot for Status factories.
- Created `spec/rails_helper.rb` to include FactoryBot::Syntax::Methods in RSpec configuration.
- Created `spec/models/subsidiary_spec.rb` to write test cases for Subsidiary model associations and callback method.
- Created `spec/graphql/mutations/subsidiaries/create_subsidiary_spec.rb` to write test cases for creating Subsidiary with admin user and non-admin user.