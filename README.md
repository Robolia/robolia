# Robolia

Robolia is a platform for bot battles on top of different games.

[![Build Status](https://travis-ci.org/Robolia/robolia.svg?branch=master)](https://travis-ci.org/Robolia/robolia)

## Prerequisites

* Elixir >= 1.8
* Erlang == 21
* Postgresql >= 16.3
* Redis >= 7.4
* Docker
* Openssl

## Installing

* You must login in Docker CLI before starting the application, by doing `docker login`
* Copy `.env.sample` to `.env` and change the values might need
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Start Phoenix endpoint with `mix phx.server`

In the background, the application will start creating the docker images for the languages. Wait untill all of them are created.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Running the tests

`source .env && mix test`

## Seed data for development

`mix run priv/repo/seeds.exs`

## Deployment

`./scripts/deploy`

## Author

* **Rafael Soares** - https://github.com/rafaels88

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
