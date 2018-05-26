defmodule GameRoomWeb.AccountController do
  use GameRoomWeb, :controller
  plug(GameRoomWeb.Plugs.Authentication)

  alias GameRoom.Accounts.{Queries, Player}
  alias GameRoom.Repo

  def index(%{assigns: %{user: user}} = conn, _) do
    players =
      Player
      |> Queries.for_user(%{id: user.id})

    conn
    |> render(
      "index.html",
      players:
        players
        |> Repo.all()
        |> Repo.preload([:game, :rating]),
      active_players:
        players
        |> Queries.active()
        |> Repo.all()
        |> Enum.count(),
      current_user: user
    )
  end
end
