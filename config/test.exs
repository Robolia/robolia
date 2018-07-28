use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :robolia, RoboliaWeb.Endpoint,
  http: [port: 4001],
  server: false

config :robolia, Robolia.Application, env: :test

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :robolia, Robolia.Repo,
  database: "robolia_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :robolia, player_script_runner: Robolia.PlayerContainerMock
