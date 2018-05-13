defmodule GameRoomWeb.Github.WebhookCreation do
  use Confex, otp_app: :game_room
  use GenServer

  @github_account_name "Robolia"
  @fork_hook_repos [
    "tic-tac-toe-elixir"
  ]

  def init(state) do
    create_fork_hook()

    {:ok, state}
  end

  def create_fork_hook do
    @fork_hook_repos |> Enum.each(fn repo_name ->
      client() |> Tentacat.Hooks.create(
        @github_account_name,
        repo_name,
        %{
          name: "web",
          active: true,
          events: ["fork"],
          config: %{
            url: fork_callback_url(),
            content_type: "json"
          }
        }
      )
    end)
  end

  def fork_callback_url do
    %URI{scheme: uri_scheme(), host: uri_host()}
    |> GameRoomWeb.Router.Helpers.github_fork_url(:create)
  end

  def client do
    Tentacat.Client.new(%{access_token: access_token()})
  end

  def access_token, do: config()[:access_token]
  def uri_scheme, do: config()[:uri_scheme]
  def uri_host, do: config()[:uri_host]
end
