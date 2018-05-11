FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir -p /jdsilveira-app
WORKDIR /jdsilveira-app
COPY Gemfile /jdsilveira-app/Gemfile
COPY Gemfile.lock /jdsilveira-app/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install
EXPOSE 4567
COPY . /jdsilveira-app