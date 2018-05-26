defmodule GameRoomWeb.MatchesController do
  use GameRoomWeb, :controller
  plug(GameRoomWeb.Plugs.Authentication)

  alias GameRoom.Games.TicTacToes.Queries
  alias GameRoom.Games.TicTacToes.TicTacToeMatch
  alias GameRoom.Repo

  def index(%{assigns: %{user: user}} = conn, _) do
    conn
    |> render("index.html", %{
      current_user: user,
      last_tic_tac_toe_matches:
        Queries.lasts(%{limit: 20})
        |> Repo.all()
        |> Repo.preload([
          :game,
          first_player: [:user, :rating],
          second_player: [:user, :rating]
        ])
    })
  end

  def user_latests(%{assigns: %{user: user}} = conn, _params) do
    conn
    |> render("user_latests.html", %{
      current_user: user,
      user_last_tic_tac_toe_matches:
        TicTacToeMatch
        |> Queries.for_user(%{id: user.id})
        |> Queries.lasts(%{limit: 20})
        |> Repo.all()
        |> Repo.preload([
          :game,
          first_player: [:user, :rating],
          second_player: [:user, :rating]
        ])
    })
  end
end
