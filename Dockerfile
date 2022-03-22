FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler -v 1.17.3

RUN bundle install

ADD . /myapp

RUN rails db:setup
RUN rm -f tmp/pids/server.pid

CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
