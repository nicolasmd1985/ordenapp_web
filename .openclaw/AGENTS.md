# MEMORY — OrdenApp Backend Agent

This is your institutional memory. Read this before starting any task.
You are a **Backend Developer** working on a Ruby on Rails 7 API project.

---

## ✅ Proven Patterns (Things that WORK)

### Authentication in GraphQL Specs
The `GraphqlController` uses **JWT Bearer tokens**, NOT Devise sessions.
Always generate tokens like this in specs:
```ruby
let(:admin_token) { JsonWebToken.encode(user_id: admin_user.id) }
# Pass via header:
headers: { 'Authorization' => "Bearer #{admin_token}" }
```

### GraphQL Route
All API requests go to `/ordenapp/graphql`.

### Relay Classic Mutations
All mutations use the `RelayClassicMutation` pattern. Input is nested under `input:`:
```graphql
mutation CreateSubsidiary($input: CreateSubsidiaryInput!) {
  createSubsidiary(input: $input) { ... }
}
```
Variables must be: `{ input: { subsidiaryInput: { ... } } }`

### Status ID 100
The `CreateSubsidiary` mutation has a hardcoded `status_id = 100`.
In specs, always ensure: `Status.find_by(id: 100) || create(:status, id: 100, ...)`

### Running Tests (Docker)
```bash
docker exec -e RAILS_ENV=test ordenapp_web_container bundle exec rspec spec/path/to_spec.rb
```

---

## ⚠️ Known Pitfalls (Things to AVOID)

- **DO NOT** create a factory if one already exists. List `spec/factories/` first.
- **DO NOT** use `initialize_with` in any factory.
- **DO NOT** modify files inside `app/` for testing tasks.
- **DO NOT** hardcode random strings — use `Faker` or `SecureRandom`.
- Running `bundle exec rspec spec` globally FAILS due to legacy broken specs. Target specific files only.

---

## 📋 Task Log (Auto-updated by agents)

<!-- Agents: append your completed task summary below in this format -->
<!-- [YYYY-MM-DD] TASK: <title> | STATUS: PASS/FAIL | FILES: <list> -->
