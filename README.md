# api-framework

An automated API / web service / integration testing framework

The framework using the following:

- [Allure Report](https://qameta.io/allure-report/) - A flexible lightweight test report tool.
- [Faker](https://github.com/faker-ruby/faker) - A library for generating fake data such as names, addresses, and phone
  numbers.
- [Pry](https://github.com/pry/pry) - A runtime developer console.
- [Rake](https://ruby.github.io/rake/) - Allows us to create tasks to manage dependencies and run our checks.
- [Rest-client](https://github.com/rest-client/rest-client) - Builds and triggers HTTP requests whilst handling
- [Rspec](https://rspec.info/) - Framework to create and organise our checks.
  responses to be used in our checks.
- [Ruby](https://www.ruby-lang.org/en/) - A popular language with testers.

The framework contains following areas:

- `spec` - stores automated checks. The tests will call functions from the API and Payload areas of the framework and be
  responsible for asserting responses.
- `api` - a library of API endpoints which are used in spec to communication
  with [restful-booker](https://restful-booker.herokuapp.com/). They are grouped based on the resource you are
  calling so if there are two resources called Booking and Auth then we create two classes named Booking and Auth. Each
  function is tied to an individual request that can be called multiple times. This means if the request changes it
  requires a single change to propagate through the framework.
- `payloads` a suite of builders to create payloads for POST requests. Payloads that are required for requests and
  responses are stored in this area. The idea is similar to the API
  area in that one class is responsible for one payload that may be called multiple times. Again, this means if the
  payload changes it requires a single change to propagate through the framework.
- `gemfile` / `Rakefile` manages the running of framework and it’s dependencies

## Tests

Suite of automated checks against the web service [restful-booker](https://restful-booker.herokuapp.com/)

## Setup

1. Clone this repository.

2. Run the following steps that install the necessary dependencies. [Bundler](https://bundler.io/) is required.

```shell
bundle install
```

## Configurations

`ENV_URL` -> defaults to [https://restful-booker.herokuapp.com](), any valid url can be passed to set the target
environment.

## Executing tests

To start tests, run:

```shell
bundle exec rake
```

or execute individual test with provided ID (symbol after test's name, which contains digits enclosed in
quotes: `tms:'101'` )

```shell
bundle exec rspec --tag tms:101
```

## Generating local HTML Allure report

To generate the report from existing Allure results you can use the following command:

```shell
allure generate report/allure-results --clean
```

When the report is generated you can open it in your default system browser. Simply run:

```shell
allure open allure-report
```

For more info, please visit: [Allure Framework official documentation](https://docs.qameta.io/allure-report)

## API documentation for the playground

[restful-booker detailed API documentation](https://restful-booker.herokuapp.com/apidoc/index.html)

## What is the builder pattern?

[@FriendlyTester](https://twitter.com/friendlytester) has
a [great blog post on what the builder pattern](http://www.thefriendlytester.co.uk/2015/06/an-introduction-to-data-builder-pattern.html)
is and it’s context to data creation.
