defmodule GameRoomWeb.MatchesController do
  use GameRoomWeb, :controller
  alias GameRoom.Games.TicTacToes.Queries
  alias GameRoom.Games.TicTacToes.TicTacToeMatch
  alias GameRoom.Repo

  def index(conn, _params) do
    case current_user(conn) do
      nil ->
        conn |> redirect(to: home_path(conn, :index))

      user ->
        conn
        |> render("index.html", %{
          current_user: user,
          last_tic_tac_toe_matches:
            Queries.lasts(%{limit: 20})
            |> Repo.all()
            |> Repo.preload([:game, first_player: :user, second_player: :user])
        })
    end
  end

  def user_latests(conn, _params) do
    case current_user(conn) do
      nil ->
        conn |> redirect(to: home_path(conn, :index))

      user ->
        conn
        |> render("user_latests.html", %{
          current_user: user,
          user_last_tic_tac_toe_matches:
            TicTacToeMatch
            |> Queries.for_user(%{id: user.id})
            |> Queries.lasts(%{limit: 20})
            |> Repo.all()
            |> Repo.preload([:game, first_player: :user, second_player: :user])
        })
    end
  end

  defp current_user(conn), do: get_session(conn, :current_user)
end
