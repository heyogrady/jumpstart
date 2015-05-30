# jumpstart
Rails starter template

[![Circle CI](https://circleci.com/gh/heyogrady/jumpstart/tree/master.svg?style=svg)](https://circleci.com/gh/heyogrady/jumpstart/tree/master)

[![Code Climate](https://codeclimate.com/github/heyogrady/jumpstart/badges/gpa.svg)](https://codeclimate.com/github/heyogrady/jumpstart)

[![Coverage Status](https://coveralls.io/repos/heyogrady/jumpstart/badge.svg)](https://coveralls.io/r/heyogrady/jumpstart)

#### Setup

```
bundle install
cp config/database.yml.postgresqlapp config/database.yml
rake setup
bundle exec rails server
```

#### Replace Jumpstart with your project name

Let's say that the project name is `Chainsaw`. Execute the command below to
replace all occurrences of `Jumpstart` with `Chainsaw`.

```
 perl -e "s/Jumpstart/Chainsaw/g;" -pi $(find . -type f)
```

#### Features

- Uses [Bootstrap](http://getbootstrap.com) .
- rake setup to set sensible sample data including user `sam@example.com` with password `welcome`.
- Uses [devise](https://github.com/plataformatec/devise) .
- Heroku ready. Push to heroku and it will work .
- Built in superadmin feature.
- Uses modal box to showcase an example of editing information using modal box.
- Enables __strict mode__ for all JavaScript code.
- Uses __unicorn__ for staging and production.
- Uses __thin__ for development and test.
- A green ribbon at the top for non-production environment.
- Uses haml for cleaner syntax over erb.
- No coffeescript. We prefer JavaScript.
- No turbolinks.
- Uses [ActiveAdmin](http://activeadmin.info).
- Uses [DelayedJob](https://github.com/collectiveidea/delayed_job).
- Intercepts all outgoing emails in non production environment using gem [mail_interceptor](https://github.com/bigbinary/mail_interceptor).
- Uses [CircleCI](https://circleci.com) for continuous testing.
- Has a bunch of tests to make it easier to get started with new tests.
- Uses PostgreSQL.
- Built in support for [carrierwave](https://github.com/carrierwaveuploader/carrierwave) to easily upload items to s3.
- Built in support for "variants" so the pages can be customized for tablet or phone easily.
- Uses [simple_form](https://github.com/plataformatec/simple_form).
- Built in support for [mandrill](http://how-we-work.bigbinary.com/externalservices/mandrill.html).
- Easy to generate "test coverage".
- Content compression via [Rack::Deflater](https://github.com/rack/rack/blob/master/lib/rack/deflater.rb).

