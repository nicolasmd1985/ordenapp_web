Task Title: backend report
Description: Title: [BACKEND] - Project Architecture & Schema Review

🎯 Goal: Perform a general review of the isolated repository and summarize your understanding to AGENT_REPORT.md at the root.

📂 Context & Review:

The project repository is organized as follows:
```plaintext
.
├── app
│   ├── config
│   │   └── routes.rb
│   ├── db
│   │   └── schema.rb
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── README.md
├── packages
├── .gitignore
```

#### Redis:

Redis is a popular key-value store used for caching, session management, and other session-related operations.
* Configuration:
    - `redis` gem in Gemfile
    - Install Redis before starting the server
* The schema defines database tables for keys, values, hashes, and sets, all stored in Redis.

#### MongoDB:

MongoDB is a NoSQL database that stores structured documents in an array format and is great for large, unstructured data sets.
* Configuration:
    - `mongoid` gem in Gemfile
    - Run `mongod` service to start the MongoDB server
    - Configuration file located in `/var/lib/mongodb` inside the Gemfile
* The schema details each collection type and fields associated with it, including indexes, data types, and validation rules.

#### Sidekiq:

Sidekiq is an asynchronous worker queue system written in Ruby, providing background processing for applications running on the Heroku platform.
* Configuration:
    - Install Sidekiq in Gemfile
    - Define worker classes and set up the workers in the Proc File
* In the schema, the job class is a definition for the Sidekiq worker.
    - `worker_class`: A string representing the class that implements the sidekiq workers. This is necessary for Sidekiq to define the job class when the worker is loaded. 
    - `queue_name`: Optional, but must be specified, for queues defined in Sidekiq’s global configuration (the `sidekiq.options[:pool][:size]` and `sidekiq.options[:pool][:size]`). 
    * The job is passed the job class and the same job class. The job class is the only way that Sidekiq can recognize the arguments it was passed in.
* The schema defines the format and structure of the job definitions and the expected parameters for Sidekiq’s workers to run.

#### Dockerfile:

Dockerfile is used to create the image that builds the final container. Contains all the instructions of how to get your application to run with the given environment.

```bash
# Use the base image
FROM ruby:2.4.2

# Set the working directory
WORKDIR /app

# Set the environment variables
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH $RBENV_ROOT/bin:$RBENV_ROOTCOMPLETIONS/completions:$PATH

# Add the required gems
RUN gem install bundler
COPY Gemfile Gemfile.lock packages/.gitattributes .gitattributes

# Install the dependencies
RUN bundle install

# Add the application code
COPY . .

# Expose the port
EXPOSE 3000

# Start the application
CMD ["ruby", "app/bin/webpack-dev-server"]

```

You can add your specific requirements, questions, or requests here by entering your own content between [Markdown begins] and [Markdown ends] tags.
[Markdown begins] [Markdown ends]