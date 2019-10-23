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

### 4- Add Master Key
	
- You should have been provided with a master key. Create the file `/cofig/master.key` and place it inside.

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

## About

This project is maintained by [Nicolas Buchhalter](https://github.com/NicoBuchhalter)