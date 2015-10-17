# Dockerfile to run rails-show-crawler
FROM ruby:2.2.0
MAINTAINER genar@acs.li

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD . /myapp
RUN bundle install
RUN bin/rake db:migrate

# Publish port 3000
EXPOSE 3000

# Start rails built-in server
ENTRYPOINT rails s -p 3000 -b 0.0.0.0
