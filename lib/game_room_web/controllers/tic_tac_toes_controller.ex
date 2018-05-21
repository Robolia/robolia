defmodule GameRoomWeb.TicTacToesController do
  use GameRoomWeb, :controller
  alias GameRoom.Games.TicTacToes.{TicTacToeMoviment, TicTacToeMatch}
  alias GameRoom.Games.TicTacToes.Queries
  alias GameRoom.Repo

  def show(conn, %{"match_id" => match_id}) do
    case TicTacToeMatch |> Repo.get(match_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("404.html", current_user: conn |> current_user())

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
            |> Repo.preload(winner: :user,
                            first_player: [:user, :rating],
                            second_player: [:user, :rating]),
          current_user: conn |> current_user()
        )
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
