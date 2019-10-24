Whitespectre Exercise
===============

[API Documentation](/docs/api.md)
---------------


## Running local server

### 1- Installing Ruby

- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 2- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler
  rbenv rehash
```

- Install all the gems included in the project.

```bash
  bundle install
```

### 3- Database Setup

- Run in terminal:

```bash
  psql postgres
  CREATE ROLE "whitespectre_exercise" LOGIN CREATEDB PASSWORD 'whitespectre_exercise';
```

- Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

### 6- Start Server

```bash
	rails server
```

## Running Tests

Tests are built using Rspec. To write new tests, add them in /spec directory.

To run them:
```bash
	bundle exec rspec spec 
```

## Tradeoffs

- `Location` attribute of a `GroupEvent` is a simple string. Normally I would have added some latitude and longitude with geolocation but as there were no specifications, for the purpose of this exercise I thought it would be ok just a string. 
- `Description` attribute is a text data. In this way, any kind of format that would like to be saved will fit.
- `Duration` attribute is not really saved in database. I just save `start_date` and `end_date` and calculate it. `GroupEvent` model has methods to set start_date and end_date given the other two, as requested.  


## About

This project is maintained by [Nicolas Buchhalter](https://github.com/NicoBuchhalter)