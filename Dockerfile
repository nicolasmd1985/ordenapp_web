FROM ruby:3.2.2

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

RUN rake assets:precompile

# Precompile assets
# RUN RAILS_ENV=production bundle exec rake assets:precompile

# Expose the port
EXPOSE 3000

# Start the server
CMD ["rails", "server", "-b", "0.0.0.0"]

# EXPOSE 3000
# CMD ["rails", "server", "-e", "production", "-b", "0.0.0.0"]