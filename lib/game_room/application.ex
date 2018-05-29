defmodule GameRoom.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    Confex.resolve_env!(:game_room)

    :ok = GameRoomWeb.Github.WebhookCreation.create_fork_hook()

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(GameRoom.Repo, []),
      supervisor(GameRoomWeb.Endpoint, []),
      worker(GameRoom.Schedulers.BattleScheduler, []),
      worker(GameRoom.PlayerContainer.Image, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GameRoom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    GameRoomWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
