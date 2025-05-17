FROM ruby:3.3
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN apt-get update && apt-get install -y postgresql-client
COPY . .
RUN chmod +x entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/app/entrypoint.sh"]
