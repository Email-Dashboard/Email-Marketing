FROM ruby:2.3.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN apt-get install -y wget
RUN apt-get install -y libc6-dev
RUN apt-get install -y libevent-dev

# Sqlite requirements
RUN apt-get install -y sqlite3 libsqlite3-dev

# SQL Server requirements
RUN wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.21.tar.gz
RUN tar -xzf freetds-1.00.21.tar.gz
RUN cd freetds-1.00.21 && ./configure --prefix=/usr/local --with-tdsver=7.3
RUN cd freetds-1.00.21 && make
RUN cd freetds-1.00.21 && make install

# Mysql requirements
RUN apt-get install -y libmysqlclient-dev

# PostgreSQL requirements
RUN apt-get install -y libpq-dev


RUN mkdir -p /smart-email-marketing/tmp/pids

WORKDIR /smart-email-marketing

RUN mkdir /var/db

ADD Gemfile /smart-email-marketing/Gemfile
ADD Gemfile.lock /smart-email-marketing/Gemfile.lock
RUN bundle install --without development test

ENV RAILS_ENV production
ENV RACK_ENV production

ADD . /smart-email-marketing

EXPOSE 8080

RUN bundle exec rake RAILS_ENV=production assets:precompile
RUN chown -R root:root /smart-email-marketing

RUN rake db:migrate RAILS_ENV=production

CMD ["puma","-C","config/puma_production.rb", "-e production"]
