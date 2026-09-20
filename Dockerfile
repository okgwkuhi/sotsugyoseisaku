FROM ruby:3.2.5
ENV APP /app
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
 && apt update -qq \
 && apt install -y build-essential mariadb-client nodejs \
 && npm install --global yarn

WORKDIR $APP

COPY Gemfile      $APP/Gemfile
COPY Gemfile.lock $APP/Gemfile.lock
RUN bundle install