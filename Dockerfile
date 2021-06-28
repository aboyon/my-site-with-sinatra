FROM ruby:2.4.1

MAINTAINER David Silveira <jdsilveira@gmail.com>

RUN apt-get update -qq

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install
EXPOSE 4567
COPY . /app
CMD ["bash"]
