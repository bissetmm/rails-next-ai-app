#!/bin/bash
set -e
bundle install
until pg_isready -h db -p 5432 -U postgres; do
  echo "Waiting for postgres..."
  sleep 2
done
rails db:prepare
exec "$@"
