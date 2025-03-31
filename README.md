Granny is an elderly application with AI features.

```sh
bin/setup
bin/dev
```

Notes: 
- User email address and user password are pre-populated in the database when signing in. 
- Procfile.dev is for bin/dev and Procfile is for Heroku

Deployment
- heroku create
- git push heroku main
- heroku: provision heroku postgres add-on
- heroku run rails db:migrate
- heroku: provision heroku key-value store for redis for sidekiq

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
