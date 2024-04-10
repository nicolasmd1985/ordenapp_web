
namespace :db do
  desc 'Create the database and run migrations'
  task create_and_migrate: :environment do
    # Create the database
    Rake::Task['db:create'].invoke

    # Run migrations
    Rake::Task['db:migrate'].invoke

    # Optionally, seed the database
    Rake::Task['db:seed'].invoke
  end
end