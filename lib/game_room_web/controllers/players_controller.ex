defmodule GameRoomWeb.PlayersController do
  use GameRoomWeb, :controller
  alias GameRoom.Repo
  alias GameRoom.Games.Game
  alias GameRoom.Accounts
  alias GameRoom.Accounts.{Player, Queries}

  def index(conn, _params) do
    players =
      Player
      |> Queries.for_user(%{id: current_user(conn).id})
      |> Repo.all()
      |> Repo.preload(:game)

    render(
      conn,
      "index.html",
      players: players,
      current_user: conn |> current_user()
    )
  end

  def new(conn, _params) do
    render(
      conn,
      "new.html",
      current_user: conn |> current_user(),
      games: Game |> Repo.all(),
      changeset: Player.changeset(%Player{})
    )
  end

  def create(conn, %{
        "player" => %{"game_id" => _, "language" => _, "repository_url" => _} = player_params
      }) do
    with _new_player <-
           player_params
           |> Map.merge(%{"user_id" => current_user(conn).id})
           |> Accounts.create_player!() do
      conn
      |> put_flash(:info, "Player created!")
      |> redirect(to: account_path(conn, :index))
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
