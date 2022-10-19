FROM ruby:3.1-bullseye

WORKDIR /usr/src/app
COPY Gemfile .
RUN bundle install

COPY app.rb .

CMD ["ruby", "./app.rb"]
