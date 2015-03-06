FROM ruby
ADD . /code
WORKDIR /code
RUN bundle install
