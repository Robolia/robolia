defmodule GameRoomWeb.AccountController do
  use GameRoomWeb, :controller
  alias GameRoom.Accounts.{Queries, Player}
  alias GameRoom.Repo

  def index(conn, _params) do
    players =
      Player
      |> Queries.for_user(%{id: current_user(conn).id})

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
      current_user: current_user(conn)
    )
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
