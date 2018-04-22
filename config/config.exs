# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :game_room, ecto_repos: [GameRoom.Repo]

# Configures the endpoint
config :game_room, GameRoomWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bKw0vpNkGGRQxxQTV7RPVDBg14a4cvpgd2edWUb21P6mLDZdK67DQJJzEG3TNcmC",
  render_errors: [view: GameRoomWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GameRoom.PubSub, adapter: Phoenix.PubSub.PG2]

#
# Configure your database
config :game_room, GameRoom.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: {:system, "DB_USERNAME", "postgres"},
  password: {:system, "DB_PASSWORD", "postgres"},
  hostname: {:system, "DB_HOSTNAME", "localhost"},
  pool_size: 10

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
