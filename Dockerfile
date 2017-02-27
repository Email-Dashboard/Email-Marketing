FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y sqlite3 libsqlite3-dev
RUN mkdir /smart-email-marketing
RUN mkdir /var/db
WORKDIR /smart-email-marketing


ADD Gemfile /smart-email-marketing/Gemfile
ADD Gemfile.lock /smart-email-marketing/Gemfile.lock
RUN bundle install
ADD . /smart-email-marketing

RUN export SECRET_TOKENMM=`rake secret`

EXPOSE 8080

RUN rake db:migrate RAILS_ENV=production
CMD ["puma","-C","config/puma_production.rb"]
