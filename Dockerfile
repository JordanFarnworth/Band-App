FROM ruby:2.2.0
MAINTAINER jyf0000@gmail.com

ENV LC_ALL C.UTF-8

RUN apt-get update
RUN apt-get install -y nodejs

RUN mkdir -p /usr/src/app
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/

WORKDIR /usr/src/app
ENV RAILS_ENV test
RUN bundle install --system
CMD mkdir /usr/src/app/tmp

# add all the rest
ADD . /usr/src/app/
