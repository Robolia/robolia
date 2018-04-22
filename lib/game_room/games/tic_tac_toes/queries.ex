defmodule GameRoom.Games.TicTacToes.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Games.Queries, as: GameQueries

  defdelegate for_game(model, attrs), to: GameQueries
  defdelegate count(query), to: GameQueries

  def for_player(query, %{id: player_id}) do
    from(
      q in query,
      where: q.first_player_id == ^player_id or q.second_player_id == ^player_id
    )
  end
end
