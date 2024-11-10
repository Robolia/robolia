defmodule Robolia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Confex, otp_app: :robolia

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Robolia.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RoboliaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    [:framework, :app_setup, :calibrations]
    |> Enum.map(fn stage -> children(stage, %{env: Application.get_env(:robolia, :env)}) end)
    |> List.flatten()
  end

  defp children(:framework, _) do
    [
      RoboliaWeb.Telemetry,
      Robolia.Repo,
      {DNSCluster, query: Application.get_env(:robolia, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Robolia.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Robolia.Finch},
      {Redix, name: :redis},
      # Start a worker by calling: Robolia.Worker.start_link(arg)
      # {Robolia.Worker, arg},
      # Start to serve requests, typically the last entry
      RoboliaWeb.Endpoint
    ]
  end

  defp children(:app_setup, %{env: :test}), do: []

  defp children(:app_setup, _) do
    [
      {RoboliaWeb.Github.WebhookCreation, []},
      {Robolia.PlayerContainer.ImagesSetup, []},
      {RoboliaWeb.Subscriber, []}
    ]
  end

  defp children(:calibrations, %{env: :test}), do: []

  defp children(:calibrations, _) do
    [{Robolia.Tasks.Calibrations.TicTacToes, []}]
  end
end
