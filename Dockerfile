FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y build-essential

WORKDIR /srv/app

COPY . .

CMD ["./bin/docker_test"]
