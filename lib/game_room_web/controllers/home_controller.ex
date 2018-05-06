defmodule GameRoomWeb.HomeController do
  use GameRoomWeb, :controller
  alias GameRoom.Games.TicTacToes.Queries, as: TicTacToesQueries
  alias GameRoom.Games.TicTacToes.TicTacToeMatch
  alias GameRoom.Repo

  def index(conn, _params) do
    case current_user(conn) do
      nil ->
        conn |> render("index.html", current_user: nil)

      user ->
        conn
        |> render("index.html", %{
          current_user: user,
          user_last_tic_tac_toe_matches:
            TicTacToeMatch
            |> TicTacToesQueries.for_user(%{id: user.id})
            |> TicTacToesQueries.lasts(%{limit: 10})
            |> Repo.all()
            |> Repo.preload([:game, first_player: :user, second_player: :user]),
          last_tic_tac_toe_matches:
            TicTacToesQueries.lasts(%{limit: 20})
            |> Repo.all()
            |> Repo.preload([:game, first_player: :user, second_player: :user])
        })
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
