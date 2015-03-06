FROM ruby:2.2.0
ADD . /code
WORKDIR /code
RUN bundle install
