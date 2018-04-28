defmodule GameRoom.Games.TicTacToes.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Games.Queries, as: GameQueries

  defdelegate count(query), to: GameQueries

  def for_match(query, %{id: match_id}) do
    from(
      q in query,
      where: q.id == ^match_id
    )
  end

  def for_player(query, %{id: player_id}) do
    from(
      q in query,
      where: q.first_player_id == ^player_id or q.second_player_id == ^player_id
    )
  end
end
