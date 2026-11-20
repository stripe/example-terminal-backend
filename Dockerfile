FROM ruby:3.3.14-alpine

RUN apk add build-base
RUN gem install bundler:2.5.22
RUN mkdir -p /www/example-terminal-backend
WORKDIR /www/example-terminal-backend
COPY . .
RUN bundle install
EXPOSE 4567

ENTRYPOINT ["ruby", "web.rb", "-o", "0.0.0.0"]
