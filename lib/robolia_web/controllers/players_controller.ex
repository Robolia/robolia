defmodule RoboliaWeb.PlayersController do
  use RoboliaWeb, :controller
  plug(RoboliaWeb.Plugs.Authentication)

  alias Robolia.Repo
  alias Robolia.Games.Game
  alias Robolia.Games.Queries, as: GameQueries
  alias Robolia.Accounts.{Player, Queries}

  def new(%{assigns: %{user: user}} = conn, _) do
    render(
      conn,
      "new.html",
      current_user: user,
      games: Game |> Repo.all(),
      games_count:
        Queries.count_bots_per_game()
        |> Queries.active()
        |> Repo.all()
        |> Enum.into(%{})
    )
  end

  def new_for_game(%{assigns: %{user: user}} = conn, %{"game_slug" => game_slug}) do
    case Game |> GameQueries.for_game(%{slug: game_slug}) |> Repo.one() do
      nil ->
        conn |> put_status(404) |> render("404.html")

      game ->
        conn
        |> render(
          "new_for_game.html",
          current_user: user,
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

  def update(%{assigns: %{user: user}} = conn, %{
        "id" => player_id,
        "player" => %{"active" => active}
      }) do
    player =
      Player
      |> Queries.for_player(%{id: player_id})
      |> Queries.for_user(%{id: user.id})
      |> Repo.one()

    case player do
      nil ->
        conn |> redirect(to: account_path(conn, :index))

      player ->
        {:ok, _} =
          player
          |> Ecto.Changeset.change(%{active: active |> String.to_existing_atom()})
          |> Repo.update()

        conn |> redirect(to: account_path(conn, :index))
    end
  end
end
