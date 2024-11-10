defmodule RoboliaWeb.Github.WebhookCreation do
  use Confex, otp_app: :robolia
  use GenServer
  use Phoenix.VerifiedRoutes, endpoint: RoboliaWeb.Endpoint, router: RoboliaWeb.Router

  @github_account_name "Robolia"
  @fork_hook_repos ["tic-tac-toe-elixir", "tic-tac-toe-python"]

  def start_link(name \\ __MODULE__, state \\ [], _opts) do
    GenServer.start_link(name, state)
  end

  def init(state) do
    send(self(), :create_fork_hook)
    {:ok, state}
  end

  def handle_info(:create_fork_hook, state) do
    Enum.each(@fork_hook_repos, fn repo_name ->
      Tentacat.Hooks.create(client(), @github_account_name, repo_name, %{
        name: "web",
        active: true,
        events: ["fork"],
        config: %{
          url: fork_callback_url(),
          content_type: "json"
        }
      })
    end)

    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  defp fork_callback_url do
    URI.to_string(%URI{
      scheme: uri_scheme(),
      host: uri_host(),
      path: "/github/fork"
    })
  end

  defp client do
    Tentacat.Client.new(%{access_token: access_token()})
  end

  defp access_token, do: config()[:access_token]
  defp uri_scheme, do: config()[:uri_scheme]
  defp uri_host, do: config()[:uri_host]
end
