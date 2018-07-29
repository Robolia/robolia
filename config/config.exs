# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :robolia, ecto_repos: [Robolia.Repo]

config :robolia, Robolia.Application,
  env: :dev,
  redis: [
    client: Redix,
    host: {:system, :string, "REDIS_HOST", "localhost"},
    port: {:system, :integer, "REDIS_PORT", 6379},
    sync_connect: true
  ]

# Configures the endpoint
config :robolia, RoboliaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bKw0vpNkGGRQxxQTV7RPVDBg14a4cvpgd2edWUb21P6mLDZdK67DQJJzEG3TNcmC",
  render_errors: [view: RoboliaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Robolia.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure your database
config :robolia, Robolia.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: {:system, "DB_USERNAME", "postgres"},
  password: {:system, "DB_PASSWORD", "postgres"},
  hostname: {:system, "DB_HOSTNAME", "localhost"},
  database: {:system, "DB_DATABASE", "robolia_dev"},
  pool_size: 10

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [send_redirect_uri: false]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")

config :robolia, player_script_runner: Robolia.PlayerContainer

config :robolia, RoboliaWeb.Github.WebhookCreation,
  access_token: {:system, "GITHUB_ACCESS_TOKEN_WEBHOOK", ""},
  uri_scheme: {:system, "URI_SCHEME", "http"},
  uri_host: {:system, "URI_HOST", "localhost:4000"}

config :robolia, Robolia.RedisClient, redis_client: Redix

config :robolia, Robolia.PlayerContainer.ImagesSetup, languages: [:elixir, :python]

config :robolia, Robolia.Tasks.Calibrations.TicTacToes,
  scheduling_hour: {:system, :integer, "CALIBRATION_SCHEDULING_HOUR", 20}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
