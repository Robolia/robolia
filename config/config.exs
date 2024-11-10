# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ueberauth, Ueberauth,
  providers: [
    github:
      {Ueberauth.Strategy.Github,
       [send_redirect_uri: false, default_scope: "user,user:email,public_repo", ignores_csrf_attack: true]}
  ]

config :robolia,
  ecto_repos: [Robolia.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :robolia, RoboliaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: RoboliaWeb.ErrorHTML, json: RoboliaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Robolia.PubSub,
  live_view: [signing_salt: "XwlRe0At"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :robolia, Robolia.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  robolia: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  robolia: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

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
import_config "#{config_env()}.exs"
