FROM ruby:3.0.3-alpine

RUN \
apk update \
&& apk upgrade \
&& apk --no-cache add ruby ruby-dev ruby-bundler ruby-json ruby-irb ruby-rake ruby-bigdecimal postgresql-dev \
&& apk --no-cache add make g++ \
&& rm -rf /var/cache/apk/*

WORKDIR /floofloo-app

COPY / .

RUN bundle install --without=test development

CMD bundle exec puma -t 5:5 -p ${PORT:-3000}