FROM ruby:3.0.0

MAINTAINER David Silveira <jdsilveira@gmail.com>

RUN apt-get update -qq

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v 2.2.3
RUN bundle install
EXPOSE 4567
COPY . /app
CMD ["bash"]
