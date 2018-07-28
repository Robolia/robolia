defmodule Robolia.Application do
  use Application
  use Confex, otp_app: :robolia

  import Supervisor.Spec

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Confex.resolve_env!(:robolia)

    opts = [strategy: :one_for_one, name: Robolia.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RoboliaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    [:framework, :app_setup, :calibrations]
    |> Enum.map(fn stage -> children(stage, config()) end)
    |> List.flatten()
  end


  defp children(:framework, _) do
    [
      supervisor(Robolia.Repo, []),
      supervisor(RoboliaWeb.Endpoint, []),
    ]
  end

  defp children(:app_setup, [env: :test]), do: []
  defp children(:app_setup, _) do
    [
      worker(RoboliaWeb.Github.WebhookCreation, []),
      worker(Robolia.PlayerContainer.ImagesSetup, [])
    ]
  end

  defp children(:calibrations, [env: :test]), do: []
  defp children(:calibrations, _) do
    [worker(Robolia.Tasks.Calibrations.TicTacToes, [])]
  end
end
