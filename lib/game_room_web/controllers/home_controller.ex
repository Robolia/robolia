defmodule GameRoomWeb.HomeController do
  use GameRoomWeb, :controller
  alias GameRoom.Games.TicTacToes.Queries, as: TicTacToesQueries
  alias GameRoom.Repo

  def index(conn, _params) do
    case current_user(conn) do
      nil ->
        conn |> render("index.html", current_user: nil)

      user ->
        conn
        |> render("index.html", %{
          current_user: user,
          last_tic_tac_toe_matches:
            TicTacToesQueries.lasts()
            |> Repo.all()
            |> Repo.preload(first_player: :user, second_player: :user)
        })
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
