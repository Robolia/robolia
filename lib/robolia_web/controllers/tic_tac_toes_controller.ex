defmodule RoboliaWeb.TicTacToesController do
  use RoboliaWeb, :controller
  plug(RoboliaWeb.Plugs.Authentication)

  alias Robolia.Games.TicTacToes.{TicTacToeMoviment, TicTacToeMatch}
  alias Robolia.Games.TicTacToes.Queries
  alias Robolia.Repo

  def show(%{assigns: %{user: user}} = conn, %{"match_id" => match_id}) do
    case TicTacToeMatch |> Repo.get(match_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.html", current_user: user)

      match ->
        moviments =
          TicTacToeMoviment
          |> Queries.for_match(match)
          |> Repo.all()
          |> Repo.preload(player: :user)

        render(
          conn,
          "show.html",
          moviments: moviments,
          match:
            match
            |> Repo.preload(
              winner: :user,
              first_player: [:user, :rating],
              second_player: [:user, :rating]
            ),
          current_user: user
        )
    end
  end
end
