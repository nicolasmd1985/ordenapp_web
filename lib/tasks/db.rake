

namespace :db do
  desc 'Create the database if it does not exist'
  task create: :environment do
    puts 'Creating the database if it does not exist...'
    system('bin/rails db:create RAILS_ENV=production') unless ActiveRecord::Base.connection_config[:database]
  end
end