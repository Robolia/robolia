defmodule Robolia.Games.TicTacToes.Queries do
  import Ecto.Query, only: [from: 2]
  alias Robolia.Games.Queries, as: GameQueries
  alias Robolia.Accounts.Queries, as: AccountQueries
  alias Robolia.Accounts.Player
  alias Robolia.Games.TicTacToes.{TicTacToeMoviment, TicTacToeMatch, TicTacToeRating}
  alias Robolia.Repo

  defdelegate count(query), to: GameQueries

  def for_match(TicTacToeMatch = query, %{id: match_id}) do
    from(
      q in query,
      where: q.id == ^match_id
    )
  end

  def for_match(TicTacToeMoviment = query, %{id: match_id}) do
    from(
      q in query,
      where: q.tic_tac_toe_match_id == ^match_id,
      order_by: q.inserted_at
    )
  end

  def for_user(TicTacToeMatch, %{id: user_id}) do
    Player
    |> AccountQueries.for_user(%{id: user_id})
    |> Repo.one()
    |> for_player()
  end

  def for_player(filters), do: for_player(TicTacToeMatch, filters)

  def for_player(TicTacToeRating = query, %{id: player_id}) do
    from(
      q in query,
      where: q.player_id == ^player_id
    )
  end

  def for_player(TicTacToeMatch = query, %{id: player_id}) do
    from(
      q in query,
      where: q.first_player_id == ^player_id or q.second_player_id == ^player_id
    )
  end

  def for_player(query, _), do: query

  def lasts(), do: lasts(TicTacToeMatch, %{limit: 10})

  def lasts(%{} = filters), do: lasts(TicTacToeMatch, filters)

  def lasts(query, %{limit: limit}) do
    from(
      q in query,
      order_by: [desc: q.inserted_at],
      limit: ^limit
    )
  end
end
