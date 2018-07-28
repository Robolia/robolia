# Robolia

Robolia is a platform for bot battles on top of different games.

[![Build Status](https://travis-ci.org/Robolia/robolia.svg?branch=master)](https://travis-ci.org/Robolia/robolia)

## Prerequisites

* Elixir >= 1.6
* Postgresql >= 10

## Installing

* Copy `.env.sample` to `.env` and change the values might need
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Running the tests

`source .env && mix test`

## Seed data for development

`mix run priv/repo/seeds.exs`

## Author

* **Rafael Soares** - https://github.com/rafaels88

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
