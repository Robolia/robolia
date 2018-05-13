defmodule GameRoomWeb.PlayersController do
  use GameRoomWeb, :controller
  alias GameRoom.Repo
  alias GameRoom.Games.Game
  alias GameRoom.Games.Queries, as: GameQueries
  alias GameRoom.Accounts.{Player, Queries}

  def new(conn, _params) do
    render(
      conn,
      "new.html",
      current_user: conn |> current_user(),
      games: Game |> Repo.all(),
      games_count:
        Queries.count_bots_per_game()
        |> Queries.active()
        |> Repo.all()
        |> Enum.into(%{})
    )
  end

  def new_for_game(conn, %{"game_slug" => game_slug}) do
    case Game |> GameQueries.for_game(%{slug: game_slug}) |> Repo.one() do
      nil ->
        conn |> put_status(404) |> render("404.html")

      game ->
        conn
        |> render(
          "new_for_game.html",
           current_user: conn |> current_user(),
           game: game |> Repo.preload([:repositories]),
           languages_count:
            game
            |> Queries.count_bots_per_language()
            |> Queries.active()
            |> Repo.all()
            |> Enum.into(%{})
         )
    end
  end

  def update(conn, %{"id" => player_id, "player" => %{"active" => active}}) do
    player = Player
             |> Queries.for_player(%{id: player_id})
             |> Queries.for_user(%{id: current_user(conn).id})
             |> Repo.one()

    case player do
      nil ->
        conn |> redirect(to: account_path(conn, :index))

      player ->
        {:ok, _} = player
                   |> Ecto.Changeset.change(%{active: active |> String.to_existing_atom })
                   |> Repo.update()

        conn |> redirect(to: account_path(conn, :index))
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
