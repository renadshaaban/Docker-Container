FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /instabug3
WORKDIR /instabug3
ADD Gemfile /instabug3/Gemfile
ADD Gemfile.lock /instabug3/Gemfile.lock
RUN bundle install
ADD . /instabug3