#!/bin/bash

set -e
# -----------------------------------------------------------
# Create database.yml script
(
cat <<EOF
development: &default
  adapter: postgresql
  encoding: utf8
  database: band_app_development
  pool: 5
  username: postgres
  password:
  host: <%= ENV['DB_PORT_5432_TCP_ADDR'] %>

test:
  <<: *default
  database: band_app_test

production:
  <<: *default
  database: band_app_production
EOF
) > config/database.yml

# -----------------------------------------------------------
# Create development-local.rb
(
cat <<EOF
config.cache_classes = true
config.action_controller.perform_caching = true
config.action_view.cache_template_loading = true
EOF
) > config/development-local.rb

# -----------------------------------------------------------
# Create domain.yml
(
cat <<EOF
test:
  domain: localhost

development:
  domain: "localhost:3000"

production:
  domain: "band_app.example.com"
  # whether this instance of band_app is served over ssl (https) or not
  # defaults to true for production, false for test/development
  ssl: true
  # files_domain: "band_appfiles.example.com"
EOF
) > config/domain.yml

rand_num=`openssl rand -base64 20`

# -----------------------------------------------------------
# Create security.yml
(
cat <<EOF
production:
  # replace this with a random string of at least 20 characters
  encryption_key: $rand_num

development:
  encryption_key: $rand_num

test:
  encryption_key: $rand_num
EOF
) > config/security.yml

echo "Building Base Image"
docker build -t band_app .

echo "Starting Postgresql"
docker run -d --name postgres-band-app postgres

sleep 5

echo "create/migrate db"
docker run --name band_app_temp --link postgres-band-app:db band_app bundle exec rake db:create
docker commit band_app_temp band_app
docker rm band_app_temp

echo "migrate db"
docker run --name band_app_temp --link postgres-band-app:db band_app bundle exec rake db:migrate
docker commit band_app_temp band_app
docker rm band_app_temp

echo "start band_app"
docker run --rm --link postgres-band-app:db band_app bundle exec rspec spec

echo "shutdown postgres and delete"
docker stop postgres-band-app
docker rm -f postgres-band-app
