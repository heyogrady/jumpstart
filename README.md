# Jumpstart
A Rails starter template

Amalgamated from BigBinary's [Wheel](http://github.com/bigbinary/wheel), Thoughtbot's [Suspenders](https://github.com/thoughtbot/suspenders) and [Upcase](http://upcase.com) - with Stripe subscription billing out of the box.

[![Circle CI](https://circleci.com/gh/heyogrady/jumpstart/tree/master.svg?style=svg)](https://circleci.com/gh/heyogrady/jumpstart/tree/master)

[![Code Climate](https://codeclimate.com/github/heyogrady/jumpstart/badges/gpa.svg)](https://codeclimate.com/github/heyogrady/jumpstart)

[![Coverage Status](https://coveralls.io/repos/heyogrady/jumpstart/badge.svg)](https://coveralls.io/r/heyogrady/jumpstart)

#### Features

- Uses [Bootstrap](http://getbootstrap.com)
- rake setup to set sample data
- Default admin user: `sam@example.com` with password `welcome`
- Uses [devise](https://github.com/plataformatec/devise) for authentication
- Oauth with Facebook, LinkedIn and Google preset - just add keys and secrets
- Heroku ready
- Full support for subscription billing with Stripe, including plans, trials, checkouts, cancellations, feature restriction, invoices and email notifications
- Uses modal box to showcase an example of editing information using modal box
- Enables __strict mode__ for all JavaScript code
- Uses __unicorn__ for staging and production
- Uses __thin__ for development and test
- A ribbon at the top for non-production environment - green for development, orange for staging
- Uses haml for cleaner syntax over erb
- Uses Javascript instead of Coffeescript
- No Turbolinks
- Uses [ActiveAdmin](http://activeadmin.info).
- Uses [DelayedJob](https://github.com/collectiveidea/delayed_job)
- Intercepts all outgoing emails in non production environment using gem [mail_interceptor](https://github.com/bigbinary/mail_interceptor)
- Uses [CircleCI](https://circleci.com) for continuous testing
- Uses [Coveralls](https://coveralls.com) for test coverage metrics
- Uses [CodeClimate](https://codeclimate.com)
- Uses [Hound](http://houndci.com) for automated style checking
- Uses Airbrake for error reporting
- Has a bunch of tests to make it easier to get started with new tests
- Uses PostgreSQL
- Support for Segment.io
- Support for Twilio
- Built in support for [carrierwave](https://github.com/carrierwaveuploader/carrierwave) to easily upload items to Amazon S3
- Built in support for "variants" so the pages can be customized for tablet or phone easily
- Uses [simple_form](https://github.com/plataformatec/simple_form)
- Built in support for [Mandrill](http://how-we-work.bigbinary.com/externalservices/mandrill.html)
- Content compression via [Rack::Deflater](https://github.com/rack/rack/blob/master/lib/rack/deflater.rb)

Setup
-----

```
bundle install
cp config/database.yml.postgresqlapp config/database.yml
rake setup
bundle exec rails server
```

#### Replace Jumpstart with your project name

Replace all occurrences of "Jumpstart" with your own project name.

Let's say that the project name is "Chainsaw". Execute the command below:

```
 perl -e "s/Jumpstart/Chainsaw/g;" -pi $(find . -type f)
```

#### Setup Stripe

* Create Stripe Account
* Add test keys to `secrets.yml`
* Create default plans:
  - free
  - lite
  - standard
  - professional
  - team
  - annual
* Add a test endpoint:
  - Mode: __test__
  - URL: `<staging-url>/stripe-webhook`
  - Events: __Select Events__
    - `invoice.payment_succeeded`
    - `customer.subscription.updated`
    - `customer.subscription.deleted`
* Add live keys as `ENV['STRIPE_PUBLISHABLE_KEY']` and `ENV['STRIPE_PUBLISHABLE_KEY']` on production deployment
* Add a live endpoint with production url and mode: `live`
