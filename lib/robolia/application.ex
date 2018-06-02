defmodule Robolia.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    Confex.resolve_env!(:robolia)

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Robolia.Repo, []),
      supervisor(RoboliaWeb.Endpoint, []),
      worker(RoboliaWeb.Github.WebhookCreation, []),
      worker(Robolia.Schedulers.BattleScheduler, []),
      worker(Robolia.PlayerContainer.Image, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Robolia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RoboliaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
