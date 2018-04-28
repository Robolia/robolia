use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :game_room, GameRoomWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :game_room, GameRoom.Repo,
  database: "game_room_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :game_room, player_script_runner: GameRoom.PlayerScriptMock
