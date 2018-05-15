defmodule GameRoomWeb.GithubForkController do
  use GameRoomWeb, :controller
  alias GameRoom.Games.GameRepository
  alias GameRoom.Games.Queries, as: GameQueries
  alias GameRoom.Accounts
  alias GameRoom.Accounts.Queries, as: AccountQueries
  alias GameRoom.Repo

  def create(
        conn,
        %{
          "repository" => %{"html_url" => main_repo_url},
          "forkee" => %{
            "html_url" => repository_url,
            "clone_url" => repository_clone_url,
            "owner" => %{"id" => github_id}
          }
        } = params
      ) do
    case AccountQueries.for_github(%{id: github_id}) |> Repo.one() do
      nil ->
        require Logger
        Logger.info("Anonymous fork >> #{inspect(params)}")
        conn |> put_status(204) |> text("")

      user ->
        game_repository =
          GameRepository
          |> GameQueries.for_repository(%{repository_url: main_repo_url})
          |> Repo.one()
          |> Repo.preload([:game])

        Accounts.create_player!(%{
          repository_url: repository_url,
          repository_clone_url: repository_clone_url,
          language: game_repository.language,
          game_id: game_repository.game.id,
          user_id: user.id
        })

        conn |> put_status(201) |> text("")
    end
  end

  def create(conn, _), do: conn |> put_status(200)
end
