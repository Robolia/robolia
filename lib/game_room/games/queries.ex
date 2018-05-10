defmodule GameRoom.Games.Queries do
  import Ecto.Query, only: [from: 2]
  alias GameRoom.Repo
  alias GameRoom.Accounts.Player
  alias GameRoom.Games.Game

  def for_game(query, %{id: game_id}) do
    from(
      q in query,
      where: q.id == ^game_id
    )
  end

  def for_game(query, %{slug: game_slug}) do
    from(
      q in query,
      where: q.slug == ^game_slug
    )
  end

  def count(query) do
    query |> Repo.aggregate(:count, :id)
  end
end
