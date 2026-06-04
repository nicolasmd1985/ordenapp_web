FROM ruby:3.2.2

# ENV RAILS_RELATIVE_URL_ROOT=/ordenapp

# Install dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    postgresql-client \
    wget \
    # curl \
    fontconfig \
    libfreetype6 \
    libjpeg62-turbo \
    libpng16-16 \
    libx11-6 \
    libxcb1 \
    libxext6 \
    libxrender1 \
    xfonts-75dpi \
    xfonts-base \
    libjpeg62-turbo

# Install real yarn package manager
RUN npm install -g yarn

# Download and install wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
RUN dpkg -i wkhtmltox_0.12.6.1-3.bookworm_amd64.deb || true
RUN apt-get install -f -y

# Clean up
RUN rm wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
COPY . .

# Install JS dependencies
RUN yarn install --check-files

# Precompile assets
RUN SECRET_KEY_BASE=dummy RAILS_ENV=production DATABASE_URL=postgresql://localhost/dummy bundle exec rake assets:precompile

# Expose the port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
